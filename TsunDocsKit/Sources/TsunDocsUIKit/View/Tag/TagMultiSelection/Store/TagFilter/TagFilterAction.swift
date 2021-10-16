//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagFilterAction: Action {
    case updateTags([Tag])
    case updateQuery(String)
}
