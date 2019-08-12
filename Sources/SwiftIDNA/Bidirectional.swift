import Foundation

extension IDNA {
    mutating func validBidirectionalString<S: StringProtocol>(_ str: S) -> Bool {
        let str = str.unicodeScalars
        
        guard let first = str.first, let last = str.last else {
            return true
        }
        
        let hasRandAL = CharacterSet.bidirectionalRandALCat.contains(first)
        let lastRandAL = CharacterSet.bidirectionalRandALCat.contains(last)
        if (hasRandAL && !lastRandAL) || (!hasRandAL && lastRandAL) {
            return false
        }
        
        var hasL = false
        
        for scalar in str {
            if ralCat.contains(scalar), !hasRandAL {
                return false
            }
            if lCat.contains(scalar) {
                hasL = true
            }
            if hasL, hasRandAL {
                return false
            }
        }
        
        return true
    }
}
