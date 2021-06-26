//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

enum TsundocListAction {
    case onAppear
    case onUpdate([Tsundoc])
    case select(Tsundoc)
    case modalDismissed
}

extension TsundocListAction: Action {}
