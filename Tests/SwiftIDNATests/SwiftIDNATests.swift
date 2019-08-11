import XCTest
@testable import SwiftIDNA

final class SwiftIDNATests: XCTestCase {
    func testMap1() {
        let input = "\u{00DF}"
        let expected = "ss"
        let computed = input.idnaMap()
        XCTAssertEqual(expected, computed)
    }
    
    func testMap2() {
        let input = "\u{0390}"
        let expected = "\u{03B9}\u{0308}\u{0301}"
        let computed = input.idnaMap()
        XCTAssertEqual(expected, computed)
    }
    
    func testMap3() {
        let input = "a\u{037A}b"
        let expected = "a\u{0020}\u{03B9}b"
        let computed = input.idnaMap()
        XCTAssertEqual(expected, computed)
    }
    
    func testMap4() {
        let input = "a\u{180B}b"
        let expected = "ab"
        let computed = input.idnaMap()
        XCTAssertEqual(expected, computed)
    }

    static var allTests = [
        ("testMap1", testMap1),
    ]
}
