//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Tag
import SwiftUI

public struct TagControlState: Equatable {
    public enum Alert {
        case failedToCreateTag
        case failedToDeleteTag
        case failedToRenameTag
    }

    // MARK: - Properties

    public var tags: [Tag] = []
    public var alert: Alert?

    // MARK: - Initializers

    public init(tags: [Tag] = [], alert: Alert? = nil) {
        self.tags = tags
        self.alert = alert
    }
}

public extension TagControlState {
    var isFailedToCreateTagAlertPresenting: Bool { alert == .failedToCreateTag }
    var isFailedToDeleteTagAlertPresenting: Bool { alert == .failedToDeleteTag }
    var isFailedToRenameTagAlertPresenting: Bool { alert == .failedToRenameTag }
}
