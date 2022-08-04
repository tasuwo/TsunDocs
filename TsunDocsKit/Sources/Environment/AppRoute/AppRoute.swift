//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Domain

public enum AppRoute {}

// MARK: - Setting

public extension AppRoute {
    struct Setting: Route {}
}

public extension Route where Self == AppRoute.Setting {
    static func setting() -> Self { .init() }
}

// MARK: - TagList

public extension AppRoute {
    struct TagList: Route {}
}

public extension Route where Self == AppRoute.TagList {
    static func tagList() -> Self { .init() }
}

// MARK: - TsundocInfo

public extension AppRoute {
    struct TsundocInfo: Route {
        public let tsundoc: Tsundoc
    }
}

public extension Route where Self == AppRoute.TsundocInfo {
    static func tsundocInfo(_ tsundoc: Tsundoc) -> Self { .init(tsundoc: tsundoc) }
}

// MARK: - TsundocList

public extension AppRoute {
    struct TsundocList: Route {
        public let title: String
        public let emptyTitle: String
        public let emptyMessage: String?
        public let isTsundocCreationEnabled: Bool
        public let query: TsundocListQuery
    }
}

public extension Route where Self == AppRoute.TsundocList {
    static func tsundocInfo(title: String,
                            emptyTile: String,
                            emptyMessage: String?,
                            isTsundocCreationEnabled: Bool,
                            query: TsundocListQuery) -> Self
    {
        .init(title: title,
              emptyTitle: emptyTile,
              emptyMessage: emptyMessage,
              isTsundocCreationEnabled: isTsundocCreationEnabled,
              query: query)
    }
}
