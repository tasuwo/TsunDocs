//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

enum TsundocListAction {
    case select(Tsundoc)
    case modalDismissed
}

extension TsundocListAction: Action {}
