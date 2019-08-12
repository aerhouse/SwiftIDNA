import Foundation

extension IDNA {
    /// Check against host label rules from RFC 1123.
    ///
    /// [RFC 1123](https://tools.ietf.org/rfc/rfc1123.txt).
    func validHostLabel(_ str: String) -> Bool {
        // Check for prohibited code points
        guard str.unicodeScalars.first(where: { !CharacterSet.prohibitedBySTD3.contains($0) }) == nil else {
            return false
        }
        
        guard str.first != "-", str.last != "-" else {
            return false
        }
        
        return true
    }
}
