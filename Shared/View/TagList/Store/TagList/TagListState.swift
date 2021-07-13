//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import TsunDocsUIKit

struct TagListState: Equatable {
    var gridState: TagGridState {
        get {
            .init(tags: controlState.tags.filter { controlState.filteredIds.contains($0.id) },
                  configuration: .init(.default))
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // NOP
        }
    }

    var controlState: TagListControlState = .init()
}

extension TagListState {
    static let mappingToGird: StateMapping<Self, TagGridState> = .init(keyPath: \.gridState)
    static let mappingToControl: StateMapping<Self, TagListControlState> = .init(keyPath: \.controlState)
}
