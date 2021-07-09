//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

struct SharedUrlEditViewState: Equatable {
    enum Alert: Equatable {
        case failedToLoadUrl
        case failedToSaveSharedUrl
    }

    var sharedUrl: URL?
    var sharedUrlTitle: String?
    var sharedUrlDescription: String?
    var sharedUrlImageUrl: URL?

    var selectedEmoji: Emoji?

    var alert: Alert?
    var isTitleEditAlertPresenting: Bool = false
}

extension SharedUrlEditViewState {
    var isAlertPresenting: Bool { alert != nil }
}

extension SharedUrlEditViewState {
    func command() -> TsundocCommand? {
        guard let url = sharedUrl else { return nil }

        let thumbnailSource: TsundocThumbnailSource? = {
            guard let url = sharedUrlImageUrl else { return nil }
            return .imageUrl(url)
        }()

        return TsundocCommand(title: sharedUrlTitle ?? "",
                              description: sharedUrlDescription,
                              url: url,
                              thumbnailSource: thumbnailSource)
    }
}
