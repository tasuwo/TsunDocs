// Generated using Sourcery 1.5.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Domain
import Foundation

public extension Tag {
    static func makeDefault(
        id: UUID = UUID(),
        name: String = "",
        tsundocsCount: Int = 0,
        searchableText: String? = nil
    ) -> Self {
        return .init(
            id: id,
            name: name,
            tsundocsCount: tsundocsCount,
            searchableText: searchableText
        )
    }
}

public extension TagCommand {
    static func makeDefault(
        name: String = ""
    ) -> Self {
        return .init(
            name: name
        )
    }
}

public extension Tsundoc {
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

public extension TsundocCommand {
    static func makeDefault(
        title: String = "",
        description: String? = nil,
        url: URL = URL(string: "https://xxx.xxxx.xx")!,
        imageUrl: URL? = nil,
        emojiAlias: String? = nil,
        tagIds: [Tag.ID] = []
    ) -> Self {
        return .init(
            title: title,
            description: description,
            url: url,
            imageUrl: imageUrl,
            emojiAlias: emojiAlias,
            tagIds: tagIds
        )
    }
}
