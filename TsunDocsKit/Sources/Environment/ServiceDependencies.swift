//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Domain

/// @mockable
public protocol HasPasteboard {
    var pasteboard: Pasteboard { get }
}

/// @mockable
public protocol HasTsundocQueryService {
    var tsundocQueryService: TsundocQueryService { get }
}

/// @mockable
public protocol HasTagQueryService {
    var tagQueryService: TagQueryService { get }
}

/// @mockable
public protocol HasTsundocCommandService {
    var tsundocCommandService: TsundocCommandService { get }
}

/// @mockable
public protocol HasTagCommandService {
    var tagCommandService: TagCommandService { get }
}

/// @mockable
public protocol HasUrlLoader {
    var urlLoader: URLLoadable { get }
}

/// @mockable
public protocol HasWebPageMetaResolver {
    var webPageMetaResolver: WebPageMetaResolvable { get }
}

/// @mockable
public protocol HasUserSettingStorage {
    var userSettingStorage: UserSettingStorage { get }
}

/// @mockable
public protocol HasSharedUserSettingStorage {
    var sharedUserSettingStorage: SharedUserSettingStorage { get }
}

/// @mockable
public protocol HasNop {}
