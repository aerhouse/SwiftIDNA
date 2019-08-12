import Foundation

public enum ToASCIIError: Error {
    case invalidHostLabel
    case containsAcePrefix
}

extension IDNA {
    mutating func toASCII(_ label: String, allowUnassigned: Bool, useSTD3ASCIIRules: Bool) throws -> String {
        var str = label
        
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
            
            // TODO: punycode
            
            str.insert(contentsOf: acePrefix, at: str.startIndex)
        }
        
        return str
    }
}

extension IDNA {
    /// Check against host label rules from RFC 1123.
    ///
    /// [RFC 1123](https://tools.ietf.org/rfc/rfc1123.txt).
    func validHostLabel(_ str: String) -> Bool {
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
