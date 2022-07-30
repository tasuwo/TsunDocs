//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public enum DefaultPickColor: String {
    case white
    case red
    case yellow
    case green
    case blue
    case gray
    case black
}

extension DefaultPickColor: PickColor {
    // MARK: - PickColor

    public static var `default`: DefaultPickColor { .white }

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

        case .gray:
            return .gray

        case .black:
            return .black
        }
    }
}
