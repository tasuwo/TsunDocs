//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import TsunDocsUIKit

struct TagSelectionViewState: Equatable {
    var multiSelectionState: TagMultiSelectionViewState = .init(tags: [])
    var controlState: TagControlState = .init()
}

extension TagSelectionViewState {
    static let mappingToMultiSelection: StateMapping<Self, TagMultiSelectionViewState> = .init(keyPath: \.multiSelectionState)
    static let mappingToControl: StateMapping<Self, TagControlState> = .init(keyPath: \.controlState)
}
