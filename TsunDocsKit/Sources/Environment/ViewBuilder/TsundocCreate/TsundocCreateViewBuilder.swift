//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

/// @mockable
public protocol TsundocCreateViewBuildable {
    @MainActor
    @ViewBuilder
    func buildTsundocCreateView(url: URL, onDone: @escaping (Bool) -> Void) -> AnyView
}
