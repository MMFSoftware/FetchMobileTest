import Combine
@testable import FetchMobileTest
import Foundation
import SwiftUI

extension DebugManager {
    class Mock: DebugManagerProtocol {
        var cancellables = Set<AnyCancellable>()
        @Published var selectedEndpoint: DebugManager.Endpoint = .regular

        var selectedEndpointValue: DebugManager.Endpoint {
            get { selectedEndpoint }
            set { selectedEndpoint = newValue }
        }

        var selectedEndpointPublisher: Published<DebugManager.Endpoint>.Publisher {
            $selectedEndpoint
        }
    }
}
