//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Domain
import Foundation

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

// MARK: - TagMultiSelection

public extension AppRoute {
    struct TagMultiSelection: Route {
        public let selectedIds: Set<Tag.ID>
    }
}

public extension Route where Self == AppRoute.TagMultiSelection {
    static func tagMultiSelection(selectedIds: Set<Tag.ID>) -> Self {
        .init(selectedIds: selectedIds)
    }
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

// MARK: - TsundocCreate

public extension AppRoute {
    struct TsundocCreate: Route {
        public let url: URL
    }
}

public extension Route where Self == AppRoute.TsundocCreate {
    static func tsundocCreate(_ url: URL) -> Self { .init(url: url) }
}

// MARK: - Browse

public extension AppRoute {
    struct Browse: Route {
        public let tsundoc: Tsundoc
    }
}

public extension Route where Self == AppRoute.Browse {
    static func browse(_ tsundoc: Tsundoc) -> Self { .init(tsundoc: tsundoc) }
}
