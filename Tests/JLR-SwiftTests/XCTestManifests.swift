import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(JLR_SwiftTests.allTests),
    ]
}
#endif
