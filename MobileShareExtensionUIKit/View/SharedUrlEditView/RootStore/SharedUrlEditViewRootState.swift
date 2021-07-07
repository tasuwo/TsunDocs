//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

struct SharedUrlEditViewRootState: Equatable {
    var edit: SharedUrlEditViewState
    var image: SharedUrlImageState
}

extension SharedUrlEditViewRootState {
    static let mappingToEdit: StateMapping<Self, SharedUrlEditViewState> = .init(keyPath: \Self.edit)
    static let mappingToImage: StateMapping<Self, SharedUrlImageState> = .init(keyPath: \Self.image)
}
