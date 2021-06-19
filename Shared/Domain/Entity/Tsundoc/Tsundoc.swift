//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation
import Smile

struct Tsundoc {
    let id: UUID
    let title: String
    let description: String?
    let url: URL
    let imageUrl: URL?
    let emojiAlias: String?
    let updatedDate: Date
    let createdDate: Date
}

extension Tsundoc {
    var thumbnailSource: TsundocThumbnailSource? {
        if let imageUrl = imageUrl {
            return .imageUrl(imageUrl)
        } else if let emojiAlias = emojiAlias,
                  Smile.isEmoji(character: Smile.replaceAlias(string: ":\(emojiAlias):"))
        {
            return .emoji(Smile.replaceAlias(string: ":\(emojiAlias):"))
        } else {
            return nil
        }
    }
}

extension Tsundoc: Identifiable {}
