//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

struct TsundocListState: Equatable {
    enum Modal: Equatable {
        case safariView(Tsundoc)
    }

    var tsundocs: [Tsundoc]
    var modal: Modal?
}

extension TsundocListState {
    init(tsundocs: [Tsundoc] = []) {
        self.tsundocs = tsundocs
        self.modal = nil
    }
}

extension TsundocListState {
    var isModalPresenting: Bool { modal != nil }
}
