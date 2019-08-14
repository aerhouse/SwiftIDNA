import XCTest
@testable import SwiftIDNA

final class ToUnicode: XCTestCase {
    var idna = IDNA()
    
    func test1() throws {
        let input = "xn--rksmrgs-5wao1o"
        let expected = "räksmörgås"
        let computed = idna.toUnicode(input, allowUnassigned: true, useSTD3ASCIIRules: true)
        XCTAssertEqual(expected, computed)
    }
}
