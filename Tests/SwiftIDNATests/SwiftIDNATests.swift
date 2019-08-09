import XCTest
@testable import SwiftIDNA

final class SwiftIDNATests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftIDNA().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
