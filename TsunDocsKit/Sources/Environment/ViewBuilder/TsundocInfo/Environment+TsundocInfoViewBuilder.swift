//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TsundocInfoViewBuilderKey: EnvironmentKey {
    private struct DefaultBuilder: TsundocInfoViewBuildable {
        func buildTsundocInfoView(tsundoc: Tsundoc) -> AnyView {
            assertionFailure("Not Implemented")
            return AnyView(EmptyView())
        }
    }

    static let defaultValue: TsundocInfoViewBuildable = DefaultBuilder()
}

public extension EnvironmentValues {
    var tsundocInfoViewBuilder: TsundocInfoViewBuildable {
        get { self[TsundocInfoViewBuilderKey.self] }
        set { self[TsundocInfoViewBuilderKey.self] = newValue }
    }
}
