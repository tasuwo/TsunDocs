//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public struct ActionButtonStyle: ButtonStyle {
    private struct InternalButton: View {
        let configuration: ButtonStyle.Configuration

        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            configuration.label
                .foregroundColor(Color.gray)
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 8)
                .background(GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: geometry.size.height / 2,
                                     style: .continuous)
                        .stroke(Color.gray, lineWidth: 2)
                })
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .opacity(isEnabled ? 1 : 0.6)
        }
    }

    // MARK: - Initializers

    public init() {}

    // MARK: - ButtonStyle

    public func makeBody(configuration: Self.Configuration) -> some View {
        InternalButton(configuration: configuration)
    }
}

struct ActionButtonStyleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                Button {
                    // NOP
                } label: {
                    Text("Action")
                }
                .buttonStyle(ActionButtonStyle())
                .padding()

                Button {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Save")
                    }
                }
                .buttonStyle(ActionButtonStyle())
                .padding()

                Button {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Save")
                    }
                }
                .buttonStyle(ActionButtonStyle())
                .padding()
                .disabled(true)
            }
            .preferredColorScheme(.light)

            VStack {
                Button {
                    // NOP
                } label: {
                    Text("Action")
                }
                .buttonStyle(ActionButtonStyle())
                .padding()

                Button {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Save")
                    }
                }
                .buttonStyle(ActionButtonStyle())
                .padding()

                Button {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Save")
                    }
                }
                .buttonStyle(ActionButtonStyle())
                .padding()
                .disabled(true)
            }
            .preferredColorScheme(.dark)
        }
    }
}
