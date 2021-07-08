//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

enum TextEditAlertAction: Action {
    case presented
    case textChanged(text: String)
    case saveActionTapped
    case cancelActionTapped
    case dismissed
}
