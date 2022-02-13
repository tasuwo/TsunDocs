//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public struct ColorCircle: View {
    // MARK: - Properties

    private let color: Color

    // MARK: - Initializers

    public init(color: Color) {
        self.color = color
    }

    // MARK: - View

    public var body: some View {
        Circle()
            .fill(color)
            .overlay {
                GeometryReader { geometry in
                    Circle()
                        .stroke(.black.opacity(0.1),
                                lineWidth: geometry.size.width / 16)
                        .shadow(color: .black.opacity(0.5),
                                radius: geometry.size.width / 16,
                                x: geometry.size.width / 32,
                                y: geometry.size.width / 32)
                        .clipShape(Circle())
                }
            }
    }
}

struct ColorCircle_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 16) {
            ColorCircle(color: .red)
            ColorCircle(color: .blue)
            ColorCircle(color: .green)
        }
        .padding()
    }
}
