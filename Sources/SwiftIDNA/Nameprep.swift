import Foundation

public enum NameprepErrors: Error {
    case invalidBidirectional
    case prohibitedOutput
    case containsUnassignedCodePoints
}

extension IDNA {
    /// Prepare international domain name labels.
    ///
    /// Specified in [RFC 3491](https://tools.ietf.org/rfc/rfc3491.txt).
    mutating func nameprep(_ str: String, allowUnassigned: Bool) throws -> String {
        // 1. Map
        // 2. Normalize
        let str = str.idnaMap().precomposedStringWithCompatibilityMapping
        
        // 3. Check for prohibited output
        _ = try str.unicodeScalars.map {
            guard !prohibited.contains($0) else {
                throw NameprepErrors.prohibitedOutput
            }
        }
        
        // 4. Check bidirectionality
        guard validBidirectionalString(str) else {
            throw NameprepErrors.invalidBidirectional
        }
        
        if !allowUnassigned {
            _ = try str.unicodeScalars.map {
                guard !unassigned.contains($0) else {
                    throw NameprepErrors.containsUnassignedCodePoints
                }
            }
        }
        
        return str
    }
}
