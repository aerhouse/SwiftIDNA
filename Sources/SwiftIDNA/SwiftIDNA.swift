import Foundation

struct IDNA {
    // Calculated character sets are stored to prevent repeated computation.
    lazy var unassigned = CharacterSet.unassigned
    lazy var prohibited = CharacterSet.prohibitedOutput
    lazy var ralCat = CharacterSet.bidirectionalRandALCat
    lazy var lCat = CharacterSet.bidirectionalLCat
    
    let acePrefix = "xn--"
}
