//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

public enum SearchableFilterAction<Item: Searchable>: Action {
    case updateItems([Item])
    case updateQuery(String)
}
