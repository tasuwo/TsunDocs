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
    private var _pasteboard: Pasteboard!  { didSet { pasteboardSetCallCount += 1 } }
    public var pasteboard: Pasteboard {
        get { return _pasteboard }
        set { _pasteboard = newValue }
    }
}

public class TsundocCreateViewBuildableMock: TsundocCreateViewBuildable {
    public init() { }

    public typealias TsundocCreateView = SampleView

    public private(set) var buildTsundocCreateViewCallCount = 0
    public var buildTsundocCreateViewHandler: ((URL, @escaping (Bool) -> Void) -> (TsundocCreateView))?
    public func buildTsundocCreateView(url: URL, onDone: @escaping (Bool) -> Void) -> TsundocCreateView {
        buildTsundocCreateViewCallCount += 1
        if let buildTsundocCreateViewHandler = buildTsundocCreateViewHandler {
            return buildTsundocCreateViewHandler(url, onDone)
        }
        fatalError("buildTsundocCreateViewHandler returns can't have a default value thus its handler must be set")
    }
}

public class SettingViewBuilderMock: SettingViewBuilder {
    public init() { }

    public typealias SettingView = SampleView

    public private(set) var buildSettingViewCallCount = 0
    public var buildSettingViewHandler: ((String) -> (SettingView))?
    public func buildSettingView(appVersion: String) -> SettingView {
        buildSettingViewCallCount += 1
        if let buildSettingViewHandler = buildSettingViewHandler {
            return buildSettingViewHandler(appVersion)
        }
        fatalError("buildSettingViewHandler returns can't have a default value thus its handler must be set")
    }
}

public class TagListBuildableMock: TagListBuildable {
    public init() { }

    public typealias TagList = SampleView

    public private(set) var buildTagListCallCount = 0
    public var buildTagListHandler: (() -> (TagList))?
    public func buildTagList() -> TagList {
        buildTagListCallCount += 1
        if let buildTagListHandler = buildTagListHandler {
            return buildTagListHandler()
        }
        fatalError("buildTagListHandler returns can't have a default value thus its handler must be set")
    }
}

public class TagMultiSelectionSheetBuildableMock: TagMultiSelectionSheetBuildable {
    public init() { }

    public typealias TagMultiSelectionSheet = SampleView

    public private(set) var buildTagMultiSelectionSheetCallCount = 0
    public var buildTagMultiSelectionSheetHandler: ((Set<Tag.ID>, @escaping ([Tag]) -> Void) -> (TagMultiSelectionSheet))?
    public func buildTagMultiSelectionSheet(selectedIds: Set<Tag.ID>, onDone: @escaping ([Tag]) -> Void) -> TagMultiSelectionSheet {
        buildTagMultiSelectionSheetCallCount += 1
        if let buildTagMultiSelectionSheetHandler = buildTagMultiSelectionSheetHandler {
            return buildTagMultiSelectionSheetHandler(selectedIds, onDone)
        }
        fatalError("buildTagMultiSelectionSheetHandler returns can't have a default value thus its handler must be set")
    }
}

public class TsundocInfoViewBuildableMock: TsundocInfoViewBuildable {
    public init() { }

    public typealias TsundocInfoView = SampleView

    public private(set) var buildTsundocInfoViewCallCount = 0
    public var buildTsundocInfoViewHandler: ((Tsundoc) -> (TsundocInfoView))?
    public func buildTsundocInfoView(tsundoc: Tsundoc) -> TsundocInfoView {
        buildTsundocInfoViewCallCount += 1
        if let buildTsundocInfoViewHandler = buildTsundocInfoViewHandler {
            return buildTsundocInfoViewHandler(tsundoc)
        }
        fatalError("buildTsundocInfoViewHandler returns can't have a default value thus its handler must be set")
    }
}

public class TsundocListBuildableMock: TsundocListBuildable {
    public init() { }

    public typealias TsundocList = SampleView

    public private(set) var buildTsundocListCallCount = 0
    public var buildTsundocListHandler: ((String, String, String?, Bool, TsundocListQuery) -> (TsundocList))?
    public func buildTsundocList(title: String, emptyTile: String, emptyMessage: String?, isTsundocCreationEnabled: Bool, query: TsundocListQuery) -> TsundocList {
        buildTsundocListCallCount += 1
        if let buildTsundocListHandler = buildTsundocListHandler {
            return buildTsundocListHandler(title, emptyTile, emptyMessage, isTsundocCreationEnabled, query)
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
    private var _tsundocQueryService: TsundocQueryService!  { didSet { tsundocQueryServiceSetCallCount += 1 } }
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
    private var _tagQueryService: TagQueryService!  { didSet { tagQueryServiceSetCallCount += 1 } }
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
    private var _tsundocCommandService: TsundocCommandService!  { didSet { tsundocCommandServiceSetCallCount += 1 } }
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
    private var _tagCommandService: TagCommandService!  { didSet { tagCommandServiceSetCallCount += 1 } }
    public var tagCommandService: TagCommandService {
        get { return _tagCommandService }
        set { _tagCommandService = newValue }
    }
}

public class HasUrlLoaderMock: HasUrlLoader {
    public init() { }
    public init(urlLoader: URLLoadable) {
        self._urlLoader = urlLoader
    }


    public private(set) var urlLoaderSetCallCount = 0
    private var _urlLoader: URLLoadable!  { didSet { urlLoaderSetCallCount += 1 } }
    public var urlLoader: URLLoadable {
        get { return _urlLoader }
        set { _urlLoader = newValue }
    }
}

public class HasWebPageMetaResolverMock: HasWebPageMetaResolver {
    public init() { }
    public init(webPageMetaResolver: WebPageMetaResolvable) {
        self._webPageMetaResolver = webPageMetaResolver
    }


    public private(set) var webPageMetaResolverSetCallCount = 0
    private var _webPageMetaResolver: WebPageMetaResolvable!  { didSet { webPageMetaResolverSetCallCount += 1 } }
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
    private var _userSettingStorage: UserSettingStorage!  { didSet { userSettingStorageSetCallCount += 1 } }
    public var userSettingStorage: UserSettingStorage {
        get { return _userSettingStorage }
        set { _userSettingStorage = newValue }
    }
}

public class HasSharedUserSettingStorageMock: HasSharedUserSettingStorage {
    public init() { }
    public init(sharedUserSettingStorage: SharedUserSettingStorage) {
        self._sharedUserSettingStorage = sharedUserSettingStorage
    }


    public private(set) var sharedUserSettingStorageSetCallCount = 0
    private var _sharedUserSettingStorage: SharedUserSettingStorage!  { didSet { sharedUserSettingStorageSetCallCount += 1 } }
    public var sharedUserSettingStorage: SharedUserSettingStorage {
        get { return _sharedUserSettingStorage }
        set { _sharedUserSettingStorage = newValue }
    }
}

public class HasNopMock: HasNop {
    public init() { }


}

