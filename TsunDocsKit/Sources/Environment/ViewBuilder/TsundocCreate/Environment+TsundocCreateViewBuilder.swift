//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TsundocCreateViewBuilderKey: EnvironmentKey {
    private struct DefaultBuilder: TsundocCreateViewBuildable {
        func buildTsundocCreateView(url: URL, onDone: @escaping (Bool) -> Void) -> AnyView {
            assertionFailure("Not Implemented")
            return AnyView(EmptyView())
        }
    }

    static let defaultValue: TsundocCreateViewBuildable = DefaultBuilder()
}

public extension EnvironmentValues {
    var tsundocCreateViewBuilder: TsundocCreateViewBuildable {
        get { self[TsundocCreateViewBuilderKey.self] }
        set { self[TsundocCreateViewBuilderKey.self] = newValue }
    }
}
