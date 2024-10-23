@testable import FetchMobileTest
import Foundation
import Testing

struct DebugManagerTests {
    struct Mocks {}

    private func makeSut() -> (DebugManagerProtocol, Mocks) {
        let debugManager = DebugManager()
        return (debugManager, .init())
    }

    @Test func testInitialEndpointValue() throws {
        let (sut, _) = makeSut()
        #expect(sut.selectedEndpointValue == .regular)
    }

    @Test func testEndpointValueUpdate() throws {
        let (sut, _) = makeSut()

        sut.selectedEndpointValue = .empty
        #expect(sut.selectedEndpointValue == .empty)

        sut.selectedEndpointValue = .malformed
        #expect(sut.selectedEndpointValue == .malformed)
    }

    @Test func testPublisherEmitsUpdates() async throws {
        let (sut, _) = makeSut()
        var emittedValues: [DebugManager.Endpoint] = []

        await confirmation("Publisher should emit all values in sequence") { done in
            let cancellable = sut.selectedEndpointPublisher.sink { value in
                emittedValues.append(value)
                if emittedValues.count == 3 {
                    done()
                }
            }

            // Change values
            sut.selectedEndpointValue = .empty
            sut.selectedEndpointValue = .malformed

            // Keep the cancellable alive until done
            _ = cancellable
        }

        #expect(emittedValues.count == 3)
        #expect(emittedValues == [.regular, .empty, .malformed])
    }

    @Test func testEndpointCases() throws {
        #expect(DebugManager.Endpoint.allCases.count == 3)
        #expect(DebugManager.Endpoint.allCases.contains(.regular))
        #expect(DebugManager.Endpoint.allCases.contains(.malformed))
        #expect(DebugManager.Endpoint.allCases.contains(.empty))
    }

    @Test func testEndpointRawValues() throws {
        #expect(DebugManager.Endpoint.regular.rawValue == "Regular Recipes endpoint")
        #expect(DebugManager.Endpoint.malformed.rawValue == "Malformed Data endpoint")
        #expect(DebugManager.Endpoint.empty.rawValue == "Empty Data endpoint")
    }

    @Test func testEndpointIdentifiable() throws {
        let endpoint = DebugManager.Endpoint.regular
        #expect(endpoint.id == endpoint.rawValue)
    }
}
