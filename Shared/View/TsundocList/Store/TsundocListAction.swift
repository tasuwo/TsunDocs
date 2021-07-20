//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

enum TsundocListAction {
    case onAppear
    case updateTsundocs([Tsundoc])
    case delete(IndexSet)
    case select(Tsundoc)
    case dismissModal
    case dismissAlert
}

extension TsundocListAction: Action {}
