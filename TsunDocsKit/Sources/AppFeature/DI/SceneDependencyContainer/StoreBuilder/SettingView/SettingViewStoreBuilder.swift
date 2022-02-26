//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

/// @mockable
protocol SettingViewStoreBuilder {
    @MainActor
    func buildSettingViewStore() -> ViewStore<SettingViewState, SettingViewAction, SettingViewDependency>
}
