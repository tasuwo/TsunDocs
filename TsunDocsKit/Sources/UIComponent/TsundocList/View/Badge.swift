//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

private struct BadgeButtonStyle: ButtonStyle {
    private struct InternalButton: View {
        let configuration: ButtonStyle.Configuration
        let backgroundColor: Color

        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            configuration.label
                .frame(width: 32, height: 32)
                .background(backgroundColor)
                .font(.system(size: 18).bold())
                .foregroundColor(Color(uiColor: UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 32 / 2, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 32 / 2, style: .continuous)
                        .stroke(Color(uiColor: UIColor.systemBackground), lineWidth: 3)
                )
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .opacity(isEnabled ? 1 : 0.6)
        }
    }

    // MARK: - Properties

    let backgroundColor: Color

    // MARK: - ButtonStyle

    func makeBody(configuration: Self.Configuration) -> some View {
        InternalButton(configuration: configuration, backgroundColor: backgroundColor)
    }
}

public struct Badge: View {
    private let image: Image
    private let backgroundColor: Color
    private let action: () -> Void

    // MARK: - Initializers

    public init(image: Image, action: @escaping () -> Void) {
        self.image = image
        self.backgroundColor = .accentColor
        self.action = action
    }

    public init(image: Image, backgroundColor: Color, action: @escaping () -> Void) {
        self.image = image
        self.backgroundColor = backgroundColor
        self.action = action
    }

    // MARK: - View

    public var body: some View {
        Button {
            action()
        } label: {
            image
        }
        .buttonStyle(BadgeButtonStyle(backgroundColor: backgroundColor))
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                Badge(image: Image(systemName: "plus")) {
                    // NOP
                }
                .padding()

                Badge(image: Image(systemName: "face.smiling"), backgroundColor: .red) {
                    // NOP
                }
                .padding()

                Badge(image: Image(systemName: "xmark")) {
                    // NOP
                }
                .padding()
                .disabled(true)
            }
        }
        .background(Color.gray)
    }
}
