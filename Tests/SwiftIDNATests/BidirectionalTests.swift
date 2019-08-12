import XCTest
@testable import SwiftIDNA

final class BidiTests: XCTestCase {
    var idna = IDNA()
    
    func testValidBidi() {
        let input = "\u{07B1}1\u{200F}"
        XCTAssertTrue(idna.validBidirectionalString(input))
    }
    
    func testMixLandRAL() {
        let input = "\u{07B1}a\u{200F}"
        XCTAssertFalse(idna.validBidirectionalString(input))
    }
    
    func testNoTrailingRAL() {
        let input = "\u{07B1}1"
        XCTAssertFalse(idna.validBidirectionalString(input))
    }
    
    func testNoLeadingRAL() {
        let input = "1\u{200F}"
        XCTAssertFalse(idna.validBidirectionalString(input))
    }
    
    static var allTests = [
        ("testValidBidi", testValidBidi),
        ("testMixLandRAL", testMixLandRAL),
        ("testNoTrailingRAL", testNoTrailingRAL),
        ("testNoLeadingRAL", testNoLeadingRAL)
    ]
}
