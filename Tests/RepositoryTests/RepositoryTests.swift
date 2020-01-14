import XCTest
@testable import Repository

final class swift_bali_document_repositoryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_bali_document_repository().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
