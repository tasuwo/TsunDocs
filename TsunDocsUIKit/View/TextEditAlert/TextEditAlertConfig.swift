//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public struct TextEditAlertConfig {
    public let title: String?
    public let message: String?
    public let placeholder: String

    public let validator: ((String?) -> Bool)?
    public let saveAction: ((String) -> Void)?
    public let cancelAction: (() -> Void)?

    // MARK: - Initializers

    public init(title: String? = nil,
                message: String? = nil,
                placeholder: String = "",
                validator: ((String?) -> Bool)? = nil,
                saveAction: ((String) -> Void)? = nil,
                cancelAction: (() -> Void)? = nil)
    {
        self.title = title
        self.message = message
        self.placeholder = placeholder
        self.validator = validator
        self.saveAction = saveAction
        self.cancelAction = cancelAction
    }
}
