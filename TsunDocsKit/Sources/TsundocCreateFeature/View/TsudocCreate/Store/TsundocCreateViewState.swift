//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import Foundation
import UIComponent

public struct TsundocCreateViewState: Equatable {
    public enum Alert: Equatable {
        case failedToSaveSharedUrl
    }

    let url: URL

    var sharedUrlTitle: String?
    var sharedUrlDescription: String?
    var sharedUrlImageUrl: URL?

    var selectedEmojiInfo: EmojiInfo?
    var selectedTags: [Tag] = []

    var isUnread: Bool = true
    var isPreparing: Bool = true

    var alert: Alert?

    public internal(set) var isSucceeded: Bool?

    // MARK: - Initializers

    public init(url: URL) {
        self.url = url
    }
}

extension TsundocCreateViewState {
    var title: String { sharedUrlTitle ?? "" }
    var isAlertPresenting: Bool { alert != nil }
}

extension TsundocCreateViewState {
    func command() -> TsundocCommand? {
        return TsundocCommand(title: sharedUrlTitle ?? "",
                              description: sharedUrlDescription,
                              url: url,
                              imageUrl: sharedUrlImageUrl,
                              emojiAlias: selectedEmojiInfo?.emoji.alias,
                              emojiBackgroundColor: selectedEmojiInfo?.backgroundColor,
                              isUnread: isUnread,
                              tagIds: selectedTags.map(\.id))
    }
}
