//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

/// @mockable(typealias: SettingView = SampleView)
public protocol SettingViewBuilder {
    associatedtype SettingView: View

    @MainActor
    func buildSettingView(appVersion: String) -> SettingView
}
