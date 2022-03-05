///
/// @Generated by Mockolo
///

import CompositeKit
import Domain
import Environment
import SwiftUI

public class HasPasteboardMock: HasPasteboard {
    public init() { }
    public init(pasteboard: Pasteboard) {
        self._pasteboard = pasteboard
    }

    public private(set) var pasteboardSetCallCount = 0
    private var _pasteboard: Pasteboard! { didSet { pasteboardSetCallCount += 1 } }
    public var pasteboard: Pasteboard {
        get { return _pasteboard }
        set { _pasteboard = newValue }
    }
}

public class SettingViewBuilderMock: SettingViewBuilder {
    public init() { }

    public private(set) var buildSettingViewCallCount = 0
    public var buildSettingViewHandler: (() -> (AnyView))?
    public func buildSettingView() -> AnyView {
        buildSettingViewCallCount += 1
        if let buildSettingViewHandler = buildSettingViewHandler {
            return buildSettingViewHandler()
        }
        fatalError("buildSettingViewHandler returns can't have a default value thus its handler must be set")
    }
}

public class TagListBuildableMock: TagListBuildable {
    public init() { }

    public private(set) var buildTagListCallCount = 0
    public var buildTagListHandler: (() -> (AnyView))?
    public func buildTagList() -> AnyView {
        buildTagListCallCount += 1
        if let buildTagListHandler = buildTagListHandler {
            return buildTagListHandler()
        }
        fatalError("buildTagListHandler returns can't have a default value thus its handler must be set")
    }
}

public class TagMultiSelectionSheetBuildableMock: TagMultiSelectionSheetBuildable {
    public init() { }

    public private(set) var buildTagMultiSelectionSheetCallCount = 0
    public var buildTagMultiSelectionSheetHandler: ((Set<Tag.ID>, @escaping ([Tag]) -> Void) -> (AnyView))?
    public func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> AnyView {
        buildTagMultiSelectionSheetCallCount += 1
        if let buildTagMultiSelectionSheetHandler = buildTagMultiSelectionSheetHandler {
            return buildTagMultiSelectionSheetHandler(selectedIds, onDone)
        }
        fatalError("buildTagMultiSelectionSheetHandler returns can't have a default value thus its handler must be set")
    }
}

public class TsundocInfoViewBuildableMock: TsundocInfoViewBuildable {
    public init() { }

    public private(set) var buildTsundocInfoViewCallCount = 0
    public var buildTsundocInfoViewHandler: ((Tsundoc) -> (AnyView))?
    public func buildTsundocInfoView(tsundoc: Tsundoc) -> AnyView {
        buildTsundocInfoViewCallCount += 1
        if let buildTsundocInfoViewHandler = buildTsundocInfoViewHandler {
            return buildTsundocInfoViewHandler(tsundoc)
        }
        fatalError("buildTsundocInfoViewHandler returns can't have a default value thus its handler must be set")
    }
}

public class TsundocListBuildableMock: TsundocListBuildable {
    public init() { }

    public private(set) var buildTsundocListCallCount = 0
    public var buildTsundocListHandler: ((String, String, String?, TsundocListQuery) -> (AnyView))?
    public func buildTsundocList(title: String, emptyTile: String, emptyMessage: String?, query: TsundocListQuery) -> AnyView {
        buildTsundocListCallCount += 1
        if let buildTsundocListHandler = buildTsundocListHandler {
            return buildTsundocListHandler(title, emptyTile, emptyMessage, query)
        }
        fatalError("buildTsundocListHandler returns can't have a default value thus its handler must be set")
    }
}

public class HasTsundocQueryServiceMock: HasTsundocQueryService {
    public init() { }
    public init(tsundocQueryService: TsundocQueryService) {
        self._tsundocQueryService = tsundocQueryService
    }

    public private(set) var tsundocQueryServiceSetCallCount = 0
    private var _tsundocQueryService: TsundocQueryService! { didSet { tsundocQueryServiceSetCallCount += 1 } }
    public var tsundocQueryService: TsundocQueryService {
        get { return _tsundocQueryService }
        set { _tsundocQueryService = newValue }
    }
}

public class HasTagQueryServiceMock: HasTagQueryService {
    public init() { }
    public init(tagQueryService: TagQueryService) {
        self._tagQueryService = tagQueryService
    }

    public private(set) var tagQueryServiceSetCallCount = 0
    private var _tagQueryService: TagQueryService! { didSet { tagQueryServiceSetCallCount += 1 } }
    public var tagQueryService: TagQueryService {
        get { return _tagQueryService }
        set { _tagQueryService = newValue }
    }
}

public class HasTsundocCommandServiceMock: HasTsundocCommandService {
    public init() { }
    public init(tsundocCommandService: TsundocCommandService) {
        self._tsundocCommandService = tsundocCommandService
    }

    public private(set) var tsundocCommandServiceSetCallCount = 0
    private var _tsundocCommandService: TsundocCommandService! { didSet { tsundocCommandServiceSetCallCount += 1 } }
    public var tsundocCommandService: TsundocCommandService {
        get { return _tsundocCommandService }
        set { _tsundocCommandService = newValue }
    }
}

public class HasTagCommandServiceMock: HasTagCommandService {
    public init() { }
    public init(tagCommandService: TagCommandService) {
        self._tagCommandService = tagCommandService
    }

    public private(set) var tagCommandServiceSetCallCount = 0
    private var _tagCommandService: TagCommandService! { didSet { tagCommandServiceSetCallCount += 1 } }
    public var tagCommandService: TagCommandService {
        get { return _tagCommandService }
        set { _tagCommandService = newValue }
    }
}

public class HasSharedUrlLoaderMock: HasSharedUrlLoader {
    public init() { }
    public init(sharedUrlLoader: SharedUrlLoadable) {
        self._sharedUrlLoader = sharedUrlLoader
    }

    public private(set) var sharedUrlLoaderSetCallCount = 0
    private var _sharedUrlLoader: SharedUrlLoadable! { didSet { sharedUrlLoaderSetCallCount += 1 } }
    public var sharedUrlLoader: SharedUrlLoadable {
        get { return _sharedUrlLoader }
        set { _sharedUrlLoader = newValue }
    }
}

public class HasWebPageMetaResolverMock: HasWebPageMetaResolver {
    public init() { }
    public init(webPageMetaResolver: WebPageMetaResolvable) {
        self._webPageMetaResolver = webPageMetaResolver
    }

    public private(set) var webPageMetaResolverSetCallCount = 0
    private var _webPageMetaResolver: WebPageMetaResolvable! { didSet { webPageMetaResolverSetCallCount += 1 } }
    public var webPageMetaResolver: WebPageMetaResolvable {
        get { return _webPageMetaResolver }
        set { _webPageMetaResolver = newValue }
    }
}

public class HasUserSettingStorageMock: HasUserSettingStorage {
    public init() { }
    public init(userSettingStorage: UserSettingStorage) {
        self._userSettingStorage = userSettingStorage
    }

    public private(set) var userSettingStorageSetCallCount = 0
    private var _userSettingStorage: UserSettingStorage! { didSet { userSettingStorageSetCallCount += 1 } }
    public var userSettingStorage: UserSettingStorage {
        get { return _userSettingStorage }
        set { _userSettingStorage = newValue }
    }
}

public class HasNopMock: HasNop {
    public init() { }
}
