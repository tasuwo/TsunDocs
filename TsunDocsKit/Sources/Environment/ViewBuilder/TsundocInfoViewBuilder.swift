//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

/// @mockable(typealias: TsundocInfoView = SampleView)
public protocol TsundocInfoViewBuildable {
    associatedtype TsundocInfoView: View

    @MainActor
    func buildTsundocInfoView(tsundoc: Tsundoc) -> TsundocInfoView
}
