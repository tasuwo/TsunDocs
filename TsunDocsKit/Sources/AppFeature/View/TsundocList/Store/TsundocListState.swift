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
        case edit(Tsundoc)
        case browse(Tsundoc, isEditing: Bool)
    }

    let query: Query
    var tsundocFilter: TsundocFilter = .default
    var isTsundocFilterActive: Bool = false
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

    var isBrowseAndEditActive: Bool {
        guard case .browse(_, isEditing: true) = navigation else { return false }
        return true
    }

    var isEditActive: Bool {
        guard case .edit = navigation else { return false }
        return true
    }

    var deletingTsundocId: Tsundoc.ID? {
        guard case let .confirmation(.delete(id)) = alert else { return nil }
        return id
    }

    var filteredTsundocs: [Tsundoc] {
        guard isTsundocFilterActive else { return tsundocs }
        switch tsundocFilter {
        case .read:
            return tsundocs.filter { !$0.isUnread }

        case .unread:
            return tsundocs.filter(\.isUnread)
        }
    }
}
