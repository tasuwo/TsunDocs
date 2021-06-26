//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import Foundation

struct SharedUrlEditViewState: Equatable {
    enum Alert: Equatable {
        case failedToLoadUrl
        case failedToSaveSharedUrl
    }

    let context: NSExtensionContext
    var sharedUrl: URL?
    var sharedUrlTitle: String?
    var sharedUrlDescription: String?
    var sharedUrlImageUrl: URL?

    var alert: Alert?
}

extension SharedUrlEditViewState {
    var isAlertPresenting: Bool { alert != nil }
}

extension SharedUrlEditViewState {
    init(_ context: NSExtensionContext) {
        self.context = context
        self.sharedUrl = nil
        self.sharedUrlTitle = nil
        self.sharedUrlDescription = nil
        self.sharedUrlImageUrl = nil
    }
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
