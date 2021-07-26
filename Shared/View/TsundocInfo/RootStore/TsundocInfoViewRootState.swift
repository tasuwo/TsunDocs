//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TsunDocsUIKit

struct TsundocInfoViewRootState: Equatable {
    var infoState: TsundocInfoViewState {
        get {
            .init(tsundoc: tsundoc, tags: tags)
        }
        set {
            tsundoc = newValue.tsundoc
            tags = newValue.tags
        }
    }

    var tagGridState: TagGridState {
        get {
            .init(tags: tags,
                  configuration: .init(.deletable),
                  alert: nil)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // NOP
        }
    }

    // MARK: - Shared

    var tags: [Tag]

    // MARK: - TsundocInfoViewState

    var tsundoc: Tsundoc
}

extension TsundocInfoViewRootState {
    static let mappingToInfo: StateMapping<Self, TsundocInfoViewState> = .init(keyPath: \Self.infoState)
    static let mappingToTagGrid: StateMapping<Self, TagGridState> = .init(keyPath: \Self.tagGridState)
}
