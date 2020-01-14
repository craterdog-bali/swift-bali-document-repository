import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(swift_bali_document_repositoryTests.allTests),
    ]
}
#endif
