import XCTest
@testable import WebService

final class WebServiceTests: XCTestCase {
    private var service: MockAPIService!
    private var expectation: XCTestExpectation!

    override func setUp() {
        service = MockAPIService(apiClient: WebService())
        expectation = expectation(description: "\(Self.description()) expecatation")
    }

    func test_web_service() async {
        do {
            let result = try await service.getTransactionList()
            XCTAssert(result.status == "success", "failed to fetch result")
            XCTAssertTrue(result.content.count>0, "no list found")
            expectation.fulfill()
            await self.waitForExpectations(timeout: 4.0,handler: nil)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    override func tearDown() {
        service = nil
        expectation = nil
    }
}
