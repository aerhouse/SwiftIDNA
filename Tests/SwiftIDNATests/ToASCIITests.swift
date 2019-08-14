import XCTest
@testable import SwiftIDNA

final class ToASCII: XCTestCase {
    var idna = IDNA()
    
    func testMapping() throws {
        let input = "testlabelß"
        let expected = "testlabelss"
        let computed = try idna.toASCII(input, allowUnassigned: true, useSTD3ASCIIRules: true)
        XCTAssertEqual(expected, computed)
    }
    
    func testAcePrefix() throws {
        let input = "räksmörgås"
        let expected = "xn--rksmrgs-5wao1o"
        let computed = try idna.toASCII(input, allowUnassigned: true, useSTD3ASCIIRules: true)
        XCTAssertEqual(expected, computed)
    }
}
