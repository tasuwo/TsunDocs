//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

struct TsundocListState: Equatable {
    enum Query: Equatable {
        case all
        case tagged(Tag.ID)
    }

    enum Alert: Equatable {
        case failedToDelete
    }

    enum Modal: Equatable {
        case safariView(Tsundoc)
    }

    let query: Query
    var tsundocs: [Tsundoc]
    var modal: Modal?
    var alert: Alert?
}

extension TsundocListState {
    init(query: Query, tsundocs: [Tsundoc] = []) {
        self.query = query
        self.tsundocs = tsundocs
    }
}

extension TsundocListState {
    var isModalPresenting: Bool { modal != nil }
    var isAlertPresenting: Bool { alert != nil }
}
