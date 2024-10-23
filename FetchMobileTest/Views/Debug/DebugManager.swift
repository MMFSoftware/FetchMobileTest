import SwiftUI

protocol DebugManagerProtocol: AnyObject {
    var selectedEndpointPublisher: Published<DebugManager.Endpoint>.Publisher { get }
    var selectedEndpointValue: DebugManager.Endpoint { get set }
}

final class DebugManager: ObservableObject, DebugManagerProtocol {
    static let shared = DebugManager()

    enum Endpoint: String, CaseIterable, Identifiable {
        case regular = "Regular Recipes endpoint"
        case malformed = "Malformed Data endpoint"
        case empty = "Empty Data endpoint"

        var id: String { rawValue }
    }

    @Published var selectedEndpoint: Endpoint = .regular

    var selectedEndpointValue: Endpoint {
        get { selectedEndpoint }
        set { selectedEndpoint = newValue }
    }

    var selectedEndpointPublisher: Published<Endpoint>.Publisher {
        $selectedEndpoint
    }
}
