//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import Foundation

public struct SharedUrlEditViewState: Equatable {
    public enum Alert: Equatable {
        case failedToLoadUrl
        case failedToSaveSharedUrl
    }

    var sharedUrl: URL?
    var sharedUrlTitle: String?
    var sharedUrlDescription: String?
    var sharedUrlImageUrl: URL?

    var selectedEmoji: Emoji?
    var selectedTags: [Tag]

    var alert: Alert?
}

extension SharedUrlEditViewState {
    var isAlertPresenting: Bool { alert != nil }
}

extension SharedUrlEditViewState {
    func command() -> TsundocCommand? {
        guard let url = sharedUrl else { return nil }
        return TsundocCommand(title: sharedUrlTitle ?? "",
                              description: sharedUrlDescription,
                              url: url,
                              imageUrl: sharedUrlImageUrl,
                              emojiAlias: selectedEmoji?.alias,
                              tagIds: selectedTags.map(\.id))
    }
}