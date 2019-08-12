import XCTest
@testable import SwiftIDNA

final class ToASCII: XCTestCase {
    var idna = IDNA()
    
    func testMapping() {
        let input = "testlabelß"
        let expected = "testlabelss"
        let computed = try! idna.toASCII(input, allowUnassigned: true, useSTD3ASCIIRules: true)
        XCTAssertEqual(expected, computed)
    }
}
