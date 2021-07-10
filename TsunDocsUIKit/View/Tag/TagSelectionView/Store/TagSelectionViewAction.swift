//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain

public enum TagSelectionViewAction: Action {
    case selected(Tag.ID)
    case deselected(Tag.ID)
    case queryUpdated(String)
}
