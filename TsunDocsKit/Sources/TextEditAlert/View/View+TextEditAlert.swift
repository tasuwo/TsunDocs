//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public extension View {
    func alert(isPresenting: Binding<Bool>, text: String, config: TextEditAlertConfig) -> some View {
        TextEditAlertWrapper(isPresenting: isPresenting, content: self, text: text, config: config)
    }
}

// MARK: - Preview

struct TextEditAlert_Previews: PreviewProvider {
    struct Container: View {
        enum Action {
            case saved(String)
            case cancelled

            var label: String {
                switch self {
                case let .saved(text):
                    return "saved \(text)"

                case .cancelled:
                    return "cancelled"
                }
            }
        }

        @State private var isPresenting = false
        @State private var message = "Initial Text"
        @State private var lastAction: Action?

        var body: some View {
            VStack {
                Text(message)
                    .padding()

                Text("Last Action is \(lastAction?.label ?? "none")")
                    .padding()

                Button("Press Me") {
                    isPresenting.toggle()
                }
                .padding()

                Button("Change Text") {
                    message = String(UUID().uuidString.prefix(6))
                }
                .padding()
            }
            .alert(isPresenting: $isPresenting,
                   text: message,
                   config: TextEditAlertConfig(title: "My Title",
                                               message: "My Message",
                                               placeholder: "Placeholder",
                                               validator: { $0?.count ?? 0 > 5 },
                                               saveAction: { lastAction = .saved($0) },
                                               cancelAction: { lastAction = .cancelled }))
        }
    }

    static var previews: some View {
        Container()
    }
}
