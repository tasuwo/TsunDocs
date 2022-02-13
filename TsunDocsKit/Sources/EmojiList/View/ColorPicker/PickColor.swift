//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public protocol PickColor: CaseIterable, RawRepresentable {
    static var `default`: Self { get }
    var swiftUIColor: Color { get }
}
