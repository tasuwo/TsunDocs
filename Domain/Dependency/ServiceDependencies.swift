//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

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
public protocol HasSharedUrlLoader {
    var sharedUrlLoader: SharedUrlLoadable { get }
}

/// @mockable
public protocol HasWebPageMetaResolver {
    var webPageMetaResolver: WebPageMetaResolvable { get }
}

/// @mockable
public protocol HasNop {}
