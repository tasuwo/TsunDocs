//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagFilterAction: Action {
    case tagsUpdated([Tag])
    case queryUpdated(String)
}
