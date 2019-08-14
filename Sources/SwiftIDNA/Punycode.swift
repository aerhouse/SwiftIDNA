import Foundation

fileprivate let base = 36
fileprivate let tmin = 1
fileprivate let tmax = 26
fileprivate let skew = 38
fileprivate let damp = 700
fileprivate let initialBias = 72
fileprivate let initialN = 128

enum PunycodeError: Error {
    case invalidBasicCodePoint
    case invalidCodePoint
    case invalidOutputIndex
    case unreachable
    case overflow
}

extension String.UnicodeScalarView {
    public func encodePunycode() throws -> String {
        var n = initialN
        var delta = 0
        var bias = initialBias
        
        var output = "".unicodeScalars
        
        for scalar in self {
            if scalar.isASCII {
                output.append(scalar)
            }
        }
        
        var h = output.count
        let basicCount = h
        if !output.isEmpty {
            // Append delimiter: `-`
            output.append(UnicodeScalar(0x2d)!)
        }
        
        var overflow = false
        while h < self.count {
            var min = 0x10FFFF // Max code point
            for scalar in self {
                if scalar.value < min, scalar.value >= n {
                    min = Int(scalar.value)
                }
            }
            
            (delta, overflow) = delta.addingReportingOverflow((min - n) * (h + 1))
            guard !overflow else { throw PunycodeError.overflow }
            
            n = min
            
            for point in self {
                if point.value < n {
                    (delta, overflow) = delta.addingReportingOverflow(1)
                    guard !overflow else { throw PunycodeError.overflow }
                }
                
                if point.value == n {
                    var q = delta
                    var k = base
                    var t: Int
                    var rem: Int
                    
                    while true {
                        if k <= bias {
                            t = tmin
                        } else if k >= bias + tmax {
                            t = tmax
                        } else {
                            t = k - bias
                        }
                        
                        if q < t {
                            break
                        }
                        
                        (q, rem) = (q - t).quotientAndRemainder(dividingBy: base - t)
                        
                        output.append(try punycodePoint(t + rem))
                        
                        k += base
                    }
                    
                    output.append(try punycodePoint(q))
                    
                    bias = adaptBias(delta: delta, numpoints: h + 1, firstExecution: h == basicCount)
                    
                    delta = 0
                    h += 1
                }
            }
            (delta, overflow) = delta.addingReportingOverflow(1)
            guard !overflow else { throw PunycodeError.overflow }
            (n, overflow) = n.addingReportingOverflow(1)
            guard !overflow else { throw PunycodeError.overflow }
        }
        
        return String(output)
    }
    
    public func decodePunycode() throws -> String {
        var output = "".unicodeScalars
        
        var start = self.startIndex
        
        if let delimiterIndex = self.lastIndex(of: UnicodeScalar(0x2d)!) {
            output.append(contentsOf: self[..<delimiterIndex])
            start = self.index(after: delimiterIndex)
        }
        
        var points = self[start...]
        
        var n = initialN
        var bias = initialBias
        var i = 0
        var oldi = i
        var w = 1
        var k = base
        var t: Int
        var q: Int
        var overflow = false
        var digit: Int
        
        while !points.isEmpty {            
            oldi = i
            w = 1
            k = base
            
            while !points.isEmpty {
                digit = try punycodePointValue(points.removeFirst())
                
                (i, overflow) = i.addingReportingOverflow(digit * w)
                guard !overflow else { throw PunycodeError.overflow }
                
                if k <= bias {
                    t = tmin
                } else if k >= bias + tmax {
                    t = tmax
                } else {
                    t = k - bias
                }
                
                if digit < t {
                    break
                }
                               
                (w, overflow) = w.multipliedReportingOverflow(by: base - t)
                guard !overflow else { throw PunycodeError.overflow }
                
                k += base
            }
            
            bias = adaptBias(delta: i - oldi, numpoints: output.count + 1, firstExecution: oldi == 0)
            
            (q, i) = i.quotientAndRemainder(dividingBy: output.count + 1)
            (n, overflow) = n.addingReportingOverflow(q)
            guard !overflow else { throw PunycodeError.overflow }
            
            guard let scalar = UnicodeScalar(n) else { throw PunycodeError.invalidCodePoint }
            let idx = output.index(output.startIndex, offsetBy: i)
            output.insert(scalar, at: idx)
            i += 1
        }
        
        return String(output)
    }
}

fileprivate func adaptBias(delta: Int, numpoints: Int, firstExecution: Bool) -> Int {
    var delta = firstExecution ? delta / damp : delta >> 1
    
    delta += delta / numpoints
    
    var k = 0
    
    // delta > ((base - tmin) * tmax) / 2
    while delta > 455 {
        // delta = delta / (base - tmin)
        delta /= 35
        k += base
    }
    // k + (((base - tmin + 1) * delta) / (delta + skew))
    return k + (base * delta) / (delta + skew)
}

fileprivate func punycodePointValue(_ codePoint: UnicodeScalar) throws -> Int {
    switch codePoint.value {
    // a-z
    case 0x61...0x7a:
        return Int(codePoint.value - 0x61)
    // 0-9
    case 0x30...0x39:
        return Int(codePoint.value - 0x16)
    // A-Z
    case 0x41...0x5a:
        return Int(codePoint.value - 0x41)
    // Return `base` otherwise
    default:
        throw PunycodeError.invalidBasicCodePoint
    }
}

fileprivate func punycodePoint(_ value: Int) throws -> UnicodeScalar {
    switch value {
    // a-z
    case 0...25:
        return UnicodeScalar(value + 0x61)!
    // 0-9
    case 26...35:
        return UnicodeScalar(value + 0x16)!
    default:
        throw PunycodeError.invalidBasicCodePoint
    }
}
