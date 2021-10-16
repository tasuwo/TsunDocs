//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

struct TextEditAlertState: Equatable {
    var title: String?
    var message: String?
    var placeholder: String
    var text: String
    var shouldReturn: Bool
    var isInvalidated: Bool
}

extension TextEditAlertState {
    init(_ config: TextEditAlertConfig) {
        title = config.title
        message = config.message
        placeholder = config.placeholder
        text = ""
        shouldReturn = false
        isInvalidated = false
    }
}
