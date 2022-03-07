//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

private struct TagListBuilderKey: EnvironmentKey {
    private struct DefaultBuilder: TagListBuildable {
        func buildTagList() -> AnyView {
            assertionFailure("Not Implemented")
            return AnyView(EmptyView())
        }
    }

    static let defaultValue: TagListBuildable = DefaultBuilder()
}

public extension EnvironmentValues {
    var tagListBuilder: TagListBuildable {
        get { self[TagListBuilderKey.self] }
        set { self[TagListBuilderKey.self] = newValue }
    }
}
