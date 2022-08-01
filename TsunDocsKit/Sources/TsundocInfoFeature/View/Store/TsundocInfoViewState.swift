//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public struct TsundocInfoViewState: Equatable {
    // MARK: - Properties

    var tsundoc: Tsundoc
    var tags: [Tag]

    // MARK: - Initializers

    public init(tsundoc: Tsundoc, tags: [Tag]) {
        self.tsundoc = tsundoc
        self.tags = tags
    }
}
