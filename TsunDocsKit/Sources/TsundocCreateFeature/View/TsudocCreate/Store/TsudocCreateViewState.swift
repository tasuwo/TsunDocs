//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import Foundation
import TsundocList

public struct TsudocCreateViewState: Equatable {
    public enum SaveResult {
        case succeeded
        case failed
    }

    public enum Alert: Equatable {
        case failedToLoadUrl
        case failedToSaveSharedUrl
    }

    var sharedUrl: URL?
    var sharedUrlTitle: String?
    var sharedUrlDescription: String?
    var sharedUrlImageUrl: URL?

    var selectedEmojiInfo: EmojiInfo?
    var selectedTags: [Tag] = []

    var isUnread: Bool = true

    var alert: Alert?

    public internal(set) var saveResult: SaveResult?

    public init() {}
}

extension TsudocCreateViewState {
    var title: String { sharedUrlTitle ?? "" }
    var isAlertPresenting: Bool { alert != nil }
}

extension TsudocCreateViewState {
    func command() -> TsundocCommand? {
        guard let url = sharedUrl else { return nil }
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
