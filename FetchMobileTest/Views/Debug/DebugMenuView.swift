import SwiftUI

struct DebugMenuView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var debugManager = DebugManager.shared
    var didSelectDebugOption: ((DebugManager.Endpoint) -> Void)?

    var body: some View {
        NavigationView {
            List {
                Section("Endpoints") {
                    ForEach(DebugManager.Endpoint.allCases) { endpoint in
                        HStack {
                            Label(
                                endpoint.rawValue,
                                systemImage: debugManager.selectedEndpoint == endpoint ? "record.circle.fill" : "circle"
                            )
                            .foregroundColor(debugManager.selectedEndpoint == endpoint ? .accentGreen : .primary)

                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            debugManager.selectedEndpoint = endpoint
                            didSelectDebugOption?(endpoint)
                        }
                    }
                }
            }
            .navigationTitle("Debug Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    DebugMenuView()
}
