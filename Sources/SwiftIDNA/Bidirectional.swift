import Foundation

extension String.UnicodeScalarView {
    func validBidirectionalString() -> Bool {
        guard let first = self.first, let last = self.last else {
            return true
        }
        
        // Prevent uneccesary recalculation of sets
        let ralCat = CharacterSet.bidirectionalRandALCat
        let lCat = CharacterSet.bidirectionalLCat
        
        let hasRandAL = CharacterSet.bidirectionalRandALCat.contains(first)
        let lastRandAL = CharacterSet.bidirectionalRandALCat.contains(last)
        if (hasRandAL && !lastRandAL) || (!hasRandAL && lastRandAL) {
            return false
        }
        
        var hasL = false
        
        for scalar in self {
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
