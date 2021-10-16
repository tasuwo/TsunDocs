//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit

enum TextEditAlertAction: Action {
    case presented
    case configUpdated(title: String?, message: String?, placeholder: String)
    case textChanged(text: String)
    case saveActionTapped
    case cancelActionTapped
    case dismissed
}
