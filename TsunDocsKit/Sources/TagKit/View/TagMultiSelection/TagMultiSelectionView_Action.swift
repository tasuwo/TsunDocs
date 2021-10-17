//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

public extension TagMultiSelectionView {
    enum Action {
        case done(selected: Set<Tag.ID>)
        case addNewTag(name: String)
    }
}
