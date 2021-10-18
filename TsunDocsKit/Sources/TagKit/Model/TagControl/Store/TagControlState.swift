//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Tag
import SwiftUI

public struct TagControlState: Equatable {
    enum Alert {
        case failedToCreateTag
    }

    var tags: [Tag] = []
    var alert: Alert?
}

extension TagControlState {
    var isFailedToCreateTagAlertPresenting: Bool { alert == .failedToCreateTag }
}
