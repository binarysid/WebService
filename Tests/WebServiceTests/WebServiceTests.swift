import XCTest
@testable import WebService

final class WebServiceTests: XCTestCase {
    private var service: MockAPIClient!

    override func setUp() {
        service = MockAPIClient()
    }

    func test_web_service() async {
        do {
            let result = try await service.getTransactionList()
            XCTAssert(result.status == "success", "failed to fetch result")
            XCTAssertTrue(result.content.count > 0, "no list found")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    override func tearDown() {
        service = nil
    }
}
