import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CodePointMapping.allTests),
        testCase(BidiTests.allTests),
    ]
}
#endif
