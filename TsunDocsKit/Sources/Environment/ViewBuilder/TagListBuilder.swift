//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

/// @mockable
public protocol TagListBuildable {
    associatedtype TagList: View

    @MainActor
    func buildTagList() -> TagList
}
