//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagGridAction: Action {
    case selected(Tag.ID)
    case deleted(Tag.ID)
}
