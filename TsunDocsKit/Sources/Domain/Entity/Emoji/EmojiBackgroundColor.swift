//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public enum EmojiBackgroundColor: String, CaseIterable {
    public static var `default`: Self = .white

    case white = "standard-white"
    case red = "standard-red"
    case yellow = "standard-yellow"
    case green = "standard-green"
    case blue = "standard-blue"
    case black = "standard-black"

    public var swiftUIColor: Color {
        switch self {
        case .white:
            return Color(Asset.white.color)

        case .red:
            return Color(Asset.red.color)

        case .yellow:
            return Color(Asset.yellow.color)

        case .green:
            return Color(Asset.green.color)

        case .blue:
            return Color(Asset.blue.color)

        case .black:
            return Color(Asset.black.color)
        }
    }
}
