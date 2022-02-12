//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public struct BarButtonStyle: ButtonStyle {
    private struct InternalButton: View {
        let configuration: ButtonStyle.Configuration

        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            configuration.label
                .foregroundColor(.accentColor)
                .frame(minWidth: 44, minHeight: 44)
        }
    }

    // MARK: - Initializers

    public init() {}

    // MARK: - ButtonStyle

    public func makeBody(configuration: Self.Configuration) -> some View {
        InternalButton(configuration: configuration)
    }
}

struct BarButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HStack {
                Button {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                    }
                }
                .buttonStyle(BarButtonStyle())

                Button {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "ellipsis")
                    }
                }
                .buttonStyle(BarButtonStyle())

                Button {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                    }
                }
                .buttonStyle(BarButtonStyle())
                .disabled(true)
            }
        }
    }
}
