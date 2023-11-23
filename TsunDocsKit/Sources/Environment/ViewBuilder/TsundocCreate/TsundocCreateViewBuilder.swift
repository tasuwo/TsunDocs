//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

/// @mockable
public protocol TsundocCreateViewBuildable {
    associatedtype TsundocCreateView: View

    @MainActor
    func buildTsundocCreateView(url: URL, onDone: @escaping (Bool) -> Void) -> TsundocCreateView
}
