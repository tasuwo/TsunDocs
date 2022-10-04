//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import Foundation

public struct TsundocListState: Equatable {
    enum Alert: Equatable {
        enum Confirmation: Equatable {
            case delete(Tsundoc.ID)
        }

        enum Plain {
            case failedToDelete
            case failedToUpdate
        }

        enum TextEdit {
            case createTsundoc
        }

        case plain(Plain)
        case confirmation(Confirmation)
        case textEdit(TextEdit)
    }

    enum Modal: Equatable {
        case tagAdditionView(Tsundoc.ID, Set<Tag.ID>)
        case emojiSelection(Tsundoc.ID, Emoji?)
        case createTsundoc(URL)
    }

    let query: TsundocListQuery
    var tsundocFilter: TsundocFilter = .default
    var isTsundocFilterActive: Bool = false
    var tsundocs: [Tsundoc]
    var modal: Modal?
    var alert: Alert?

    // MARK: - Initializers

    public init(query: TsundocListQuery, tsundocs: [Tsundoc] = []) {
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

    var isTsundocUrlEditAlertPresenting: Bool {
        guard case .textEdit(.createTsundoc) = alert else { return false }
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
