import Foundation

extension IDNA {
    public mutating func toUnicode<S: StringProtocol>(_ label: S, allowUnassigned: Bool, useSTD3ASCIIRules: Bool) -> String {
        var str = String(label)
        
        // Check for non-ASCII characters
        if str.first(where: { !$0.isASCII }) != nil {
            if let prepped = try? nameprep(str, allowUnassigned: allowUnassigned) {
                str = prepped
            } else {
                return String(label)
            }
        }
        
        guard str.hasPrefix(acePrefix) else { return String(label) }
        
        guard let decoded = try? String(str.dropFirst(acePrefix.count))
            .unicodeScalars
            .decodePunycode()
            else {
                return String(label)
        }
        
        guard let encoded = try? self.toASCII(decoded,
                                              allowUnassigned: allowUnassigned,
                                              useSTD3ASCIIRules: useSTD3ASCIIRules),
            label.caseInsensitiveCompare(encoded) == .orderedSame
            else {
                return String(label)
        }
        
        return decoded
    }
}
