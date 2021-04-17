import XCTest
@testable import JLR_Swift

final class JLR_SwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(JLR_Swift().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
