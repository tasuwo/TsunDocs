//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public enum EmojiBackgroundColor: String, CaseIterable {
    public static var `default`: Self = .white

    case white = "default-white"
    case red = "default-red"
    case yellow = "default-yellow"
    case green = "default-green"
    case blue = "default-blue"
    case black = "default-black"

    public var swiftUIColor: Color {
        switch self {
        case .white:
            return .white

        case .red:
            return .red

        case .yellow:
            return .yellow

        case .green:
            return .green

        case .blue:
            return .blue

        case .black:
            return .black
        }
    }
}
