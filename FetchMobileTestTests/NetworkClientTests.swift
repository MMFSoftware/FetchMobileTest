@testable import FetchMobileTest
import Foundation
import Testing

struct NetworkClientTests {
    struct Mocks {
        let mockURLSession: MockURLSession
    }

    private func makeSut() -> (NetworkClient, Mocks) {
        let mockURLSession = MockURLSession()
        return (
            NetworkClient(session: mockURLSession),
            .init(mockURLSession: mockURLSession)
        )
    }

    @Test func testFetchDecodableSuccess() async throws {
        let (sut, mocks) = makeSut()
        let expectedModel = MockModel(id: 1)
        let responseData = try JSONEncoder().encode(expectedModel)

        let url = try #require(URL(string: "https://example.com"))
        let response = try #require(
            HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )

        mocks.mockURLSession.mockedData = responseData
        mocks.mockURLSession.mockedResponse = response

        do {
            let model: MockModel = try await sut.fetch(endpoint: MockEndpoint(urlString: "https://example.com"))
            #expect(model.id == expectedModel.id)
        } catch {
            Issue.record("Fetching model failed with error: \(error)")
        }
    }

    @Test func testFetchDecodableFailure() async throws {
        let (sut, mocks) = makeSut()
        let url = try #require(URL(string: "https://example.com"))
        let response = try #require(
            HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )
        )

        mocks.mockURLSession.mockedData = nil
        mocks.mockURLSession.mockedResponse = response

        do {
            let _: MockModel = try await sut.fetch(endpoint: MockEndpoint(urlString: "https://example.com"))
            Issue.record("Fetching model should have failed")
        } catch {
            #expect(error is NetworkError, "Expected NetworkError but got \(type(of: error))")
        }
    }
}
