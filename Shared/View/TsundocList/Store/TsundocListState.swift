//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

struct TsundocListState: Equatable {
    enum Alert: Equatable {
        case failedToDelete
    }

    enum Modal: Equatable {
        case safariView(Tsundoc)
    }

    var tsundocs: [Tsundoc]
    var modal: Modal?
    var alert: Alert?
}

extension TsundocListState {
    init(tsundocs: [Tsundoc] = []) {
        self.tsundocs = tsundocs
        self.modal = nil
    }
}

extension TsundocListState {
    var isModalPresenting: Bool { modal != nil }
    var isAlertPresenting: Bool { alert != nil }
}
