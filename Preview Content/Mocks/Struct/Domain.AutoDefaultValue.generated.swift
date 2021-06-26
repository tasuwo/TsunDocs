// Generated using Sourcery 1.4.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Domain

extension Tag {
    static func makeDefault(
        id: UUID = UUID(),
        name: String = ""
    ) -> Self {
        return .init(
            id: id,
            name: name
        )
    }
}

extension TagCommand {
    static func makeDefault(
        name: String = ""
    ) -> Self {
        return .init(
            name: name
        )
    }
}

extension Tsundoc {
    static func makeDefault(
        id: UUID = UUID(),
        title: String = "",
        description: String? = nil,
        url: URL = URL(string: "https://xxx.xxxx.xx")!,
        imageUrl: URL? = nil,
        emojiAlias: String? = nil,
        updatedDate: Date = Date(timeIntervalSince1970: 0),
        createdDate: Date = Date(timeIntervalSince1970: 0)
    ) -> Self {
        return .init(
            id: id,
            title: title,
            description: description,
            url: url,
            imageUrl: imageUrl,
            emojiAlias: emojiAlias,
            updatedDate: updatedDate,
            createdDate: createdDate
        )
    }
}

extension TsundocCommand {
    static func makeDefault(
        title: String = "",
        description: String? = nil,
        url: URL = URL(string: "https://xxx.xxxx.xx")!,
        thumbnailSource: TsundocThumbnailSource? = nil
    ) -> Self {
        return .init(
            title: title,
            description: description,
            url: url,
            thumbnailSource: thumbnailSource
        )
    }
}
