import Foundation

public enum ToASCIIError: Error {
    case invalidHostLabel
    case containsAcePrefix
    case invalidLabelLength
}

extension IDNA {
    /// Convert a unicode label to IDN-compatible ASCII.
    ///
    /// - Parameter label: Label to convert.
    /// - Parameter allowUnassigned: Allow code points unassigned as of Unicode 3.2
    /// - Parameter useSTD3ASCIIRules: Confine the label to letters, digits, and the hyphen-minus.
    public mutating func toASCII<S: StringProtocol>(_ label: S, allowUnassigned: Bool, useSTD3ASCIIRules: Bool) throws -> String {
        var str = String(label)
        
        // Check for non-ASCII characters
        if str.first(where: { !$0.isASCII }) != nil {
            str = try nameprep(str, allowUnassigned: allowUnassigned)
        }
        
        if useSTD3ASCIIRules {
            guard validHostLabel(str) else {
                throw ToASCIIError.invalidHostLabel
            }
        }
        
        // Check prepped string for non-ASCII characters
        if str.first(where: { !$0.isASCII }) != nil {
            guard !str.hasPrefix(acePrefix) else {
                throw ToASCIIError.containsAcePrefix
            }
            
            str = try str.unicodeScalars.encodePunycode()
            
            str.insert(contentsOf: acePrefix, at: str.startIndex)
        }
        
        guard str.count >= 1, str.count <= 63 else { throw ToASCIIError.invalidLabelLength }
        
        return str
    }
}

extension IDNA {
    /// Check against host label rules from RFC 1123.
    ///
    /// [RFC 1123](https://tools.ietf.org/rfc/rfc1123.txt).
    func validHostLabel<S: StringProtocol>(_ str: S) -> Bool {
        // Check for prohibited code points
        guard str.unicodeScalars.first(where: { CharacterSet.prohibitedBySTD3.contains($0) }) == nil else {
            return false
        }
        
        guard str.first != "-", str.last != "-" else {
            return false
        }
        
        return true
    }
}
