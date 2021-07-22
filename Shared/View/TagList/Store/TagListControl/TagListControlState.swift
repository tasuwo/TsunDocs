//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

struct TagListControlState: Equatable {
    enum Alert: Equatable {
        enum Plain: Equatable {
            case failedToAddTag
            case failedToDeleteTag
            case failedToUpdateTag
        }

        enum Edit: Equatable {
            case addition
            case rename(Tag.ID)
        }

        case plain(Plain)
        case edit(Edit)
    }

    enum Navigation: Equatable {
        case tsundocList(Tag.ID)
    }

    var tags: [Tag] = []
    var lastHandledQuery: String?
    var filteredIds: Set<Tag.ID> = .init()
    var storage: SearchableStorage<Tag> = .init()
    var alert: Alert?
    var navigation: Navigation?
}

extension TagListControlState {
    var renamingTagId: Tag.ID? {
        guard case let .edit(.rename(tagId)) = alert else { return nil }
        return tagId
    }

    var renamingTagName: String? {
        guard case let .edit(.rename(tagId)) = alert else { return nil }
        return tags.first(where: { $0.id == tagId })?.name
    }
}

extension TagListControlState {
    var isAlertPresenting: Bool {
        switch alert {
        case .plain:
            return true

        default:
            return false
        }
    }

    var isTagAdditionAlertPresenting: Bool {
        switch alert {
        case .edit(.addition):
            return true

        default:
            return false
        }
    }

    var isRenameAlertPresenting: Bool {
        switch alert {
        case .edit(.rename):
            return true

        default:
            return false
        }
    }

    var isTsundocListNavigationActive: Bool {
        guard case .tsundocList = navigation else { return false }
        return true
    }
}
