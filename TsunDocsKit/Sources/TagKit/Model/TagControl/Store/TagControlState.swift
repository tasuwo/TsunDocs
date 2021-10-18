//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Tag
import SwiftUI

public struct TagControlState: Equatable {
    enum Alert {
        case failedToCreateTag
        case failedToDeleteTag
        case failedToRenameTag
    }

    var tags: [Tag] = []
    var alert: Alert?

    public init() {}
}

extension TagControlState {
    var isFailedToCreateTagAlertPresenting: Bool { alert == .failedToCreateTag }
    var isFailedToDeleteTagAlertPresenting: Bool { alert == .failedToDeleteTag }
    var isFailedToRenameTagAlertPresenting: Bool { alert == .failedToRenameTag }
}
