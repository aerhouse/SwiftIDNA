import Foundation

@available(OSX 10.15, iOS 13.0, tvOS 13.0, *)
extension URL {
    public init?<S: StringProtocol>(idnString: S) {
        if let hostRange = extractPotentialHost(idnString) {
            let labels = replaceLabelSeparators(idnString[hostRange]).split(separator: ".")
            
            var idna = IDNA()
            do {
                let idnLabels = try labels.map {
                    try idna.toASCII($0, allowUnassigned: true, useSTD3ASCIIRules: true)
                }
                
                let idnHost = idnLabels.joined(separator: ".")
                
                let urlString = idnString.replacingCharacters(in: hostRange, with: idnHost)
                
                guard urlString.count <= 253 else { return nil }
                
                if let url = URL(string: urlString) {
                    self = url
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public var idn: String? {
        guard let host = self.host else { return nil }
        
        let labels = host.split(separator: ".")
        
        var idna = IDNA()
        let idnLabels = labels.map {
            idna.toUnicode($0, allowUnassigned: true, useSTD3ASCIIRules: true)
        }
        
        return idnLabels.joined(separator: ".")
    }
}

func replaceLabelSeparators<S: StringProtocol>(_ host: S) -> String {
    let str = host.replacingOccurrences(of: "\u{3002}", with: ".")
                  .replacingOccurrences(of: "\u{ff0e}", with: ".")
                  .replacingOccurrences(of: "\u{ff61}", with: ".")
    return str
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, *)
func extractPotentialHost<S: StringProtocol>(_ str: S) -> Range<String.Index>? {
    // Look for anything between a `://` (optionally followed by stuff and a `@`)
    //  and one of `:/?#`.
    // Does not try to check for valid URIs.
    let pattern = ##"^.+://(?:.*@)?([^:/\?#]+)"##
    let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)

    let nsrange = NSRange(str.startIndex ..< str.endIndex, in: str)

    let match = regex.matches(in: String(str), options: [], range: nsrange)
    if let match = match.first,
       let range = Range(match.range(at: 1), in: str)
    {
        return range
    }
    
    return nil
}
