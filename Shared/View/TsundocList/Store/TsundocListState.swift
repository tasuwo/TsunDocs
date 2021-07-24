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
        enum Confirmation: Equatable {
            case delete(Tsundoc.ID)
        }

        enum Plain {
            case failedToDelete
            case failedToUpdate
        }

        case plain(Plain)
        case confirmation(Confirmation)
    }

    enum Modal: Equatable {
        case tagAdditionView(Tsundoc.ID, Set<Tag.ID>)
    }

    enum Navigation: Equatable {
        case browse(Tsundoc)
    }

    let query: Query
    var tsundocs: [Tsundoc]
    var modal: Modal?
    var alert: Alert?
    var navigation: Navigation?
}

extension TsundocListState {
    init(query: Query, tsundocs: [Tsundoc] = []) {
        self.query = query
        self.tsundocs = tsundocs
    }
}

extension TsundocListState {
    var isModalPresenting: Bool { modal != nil }

    var isAlertPresenting: Bool {
        guard case .plain = alert else { return false }
        return true
    }

    var isBrowseActive: Bool {
        guard case .browse = navigation else { return false }
        return true
    }

    var deletingTsundocId: Tsundoc.ID? {
        guard case let .confirmation(.delete(id)) = alert else { return nil }
        return id
    }
}
