///
/// @Generated by Mockolo
///

import Combine
import CoreData
import Domain
import Foundation
import Kanna

public class HasPasteboardMock: HasPasteboard {
    public init() { }
    public init(pasteboard: Pasteboard = PasteboardMock()) {
        self.pasteboard = pasteboard
    }

    public private(set) var pasteboardSetCallCount = 0
    public var pasteboard: Pasteboard = PasteboardMock() { didSet { pasteboardSetCallCount += 1 } }
}

public class PasteboardMock: Pasteboard {
    public init() { }

    public private(set) var setCallCount = 0
    public var setHandler: ((String) -> Void)?
    public func set(_ text: String) {
        setCallCount += 1
        if let setHandler = setHandler {
            setHandler(text)
        }
    }

    public private(set) var getCallCount = 0
    public var getHandler: (() -> (String?))?
    public func get() -> String? {
        getCallCount += 1
        if let getHandler = getHandler {
            return getHandler()
        }
        return nil
    }
}

public class TagCommandServiceMock: TagCommandService {
    public init() { }

    public private(set) var performCallCount = 0
    public var performHandler: ((@escaping () -> Void) -> Void)?
    public func perform(_ block: @escaping () -> Void) {
        performCallCount += 1
        if let performHandler = performHandler {
            performHandler(block)
        }
    }

    public private(set) var createTagCallCount = 0
    public var createTagHandler: ((TagCommand) -> (Result<Tag.ID, CommandServiceError>))?
    public func createTag(by command: TagCommand) -> Result<Tag.ID, CommandServiceError> {
        createTagCallCount += 1
        if let createTagHandler = createTagHandler {
            return createTagHandler(command)
        }
        fatalError("createTagHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var performBlockCallCount = 0
    public var performBlockHandler: ((@escaping () throws -> Any) throws -> (Any))?
    public func perform<T>(_ block: @escaping () throws -> T) throws -> T {
        performBlockCallCount += 1
        if let performBlockHandler = performBlockHandler {
            return try performBlockHandler(block) as! T
        }
        fatalError("performBlockHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var updateTagCallCount = 0
    public var updateTagHandler: ((Tag.ID, String) -> (Result<Void, CommandServiceError>))?
    public func updateTag(having id: Tag.ID, nameTo name: String) -> Result<Void, CommandServiceError> {
        updateTagCallCount += 1
        if let updateTagHandler = updateTagHandler {
            return updateTagHandler(id, name)
        }
        fatalError("updateTagHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var beginCallCount = 0
    public var beginHandler: (() throws -> Void)?
    public func begin() throws {
        beginCallCount += 1
        if let beginHandler = beginHandler {
            try beginHandler()
        }
    }

    public private(set) var commitCallCount = 0
    public var commitHandler: (() throws -> Void)?
    public func commit() throws {
        commitCallCount += 1
        if let commitHandler = commitHandler {
            try commitHandler()
        }
    }

    public private(set) var cancelCallCount = 0
    public var cancelHandler: (() throws -> Void)?
    public func cancel() throws {
        cancelCallCount += 1
        if let cancelHandler = cancelHandler {
            try cancelHandler()
        }
    }

    public private(set) var deleteTagCallCount = 0
    public var deleteTagHandler: ((Tag.ID) -> (Result<Void, CommandServiceError>))?
    public func deleteTag(having id: Tag.ID) -> Result<Void, CommandServiceError> {
        deleteTagCallCount += 1
        if let deleteTagHandler = deleteTagHandler {
            return deleteTagHandler(id)
        }
        fatalError("deleteTagHandler returns can't have a default value thus its handler must be set")
    }
}

public class TagQueryServiceMock: TagQueryService {
    public init() { }

    public private(set) var fetchTagsCallCount = 0
    public var fetchTagsHandler: ((Tsundoc.ID) -> (Result<Set<Tag>, QueryServiceError>))?
    public func fetchTags(taggedToTsundocHaving id: Tsundoc.ID) -> Result<Set<Tag>, QueryServiceError> {
        fetchTagsCallCount += 1
        if let fetchTagsHandler = fetchTagsHandler {
            return fetchTagsHandler(id)
        }
        fatalError("fetchTagsHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var queryTagCallCount = 0
    public var queryTagHandler: ((Tag.ID) -> (Result<AnyObservedEntity<Tag>, QueryServiceError>))?
    public func queryTag(having id: Tag.ID) -> Result<AnyObservedEntity<Tag>, QueryServiceError> {
        queryTagCallCount += 1
        if let queryTagHandler = queryTagHandler {
            return queryTagHandler(id)
        }
        fatalError("queryTagHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var queryTagsCallCount = 0
    public var queryTagsHandler: ((Tsundoc.ID) -> (Result<AnyObservedEntityArray<Tag>, QueryServiceError>))?
    public func queryTags(taggedToTsundocHaving id: Tsundoc.ID) -> Result<AnyObservedEntityArray<Tag>, QueryServiceError> {
        queryTagsCallCount += 1
        if let queryTagsHandler = queryTagsHandler {
            return queryTagsHandler(id)
        }
        fatalError("queryTagsHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var queryAllTagsCallCount = 0
    public var queryAllTagsHandler: (() -> (Result<AnyObservedEntityArray<Tag>, QueryServiceError>))?
    public func queryAllTags() -> Result<AnyObservedEntityArray<Tag>, QueryServiceError> {
        queryAllTagsCallCount += 1
        if let queryAllTagsHandler = queryAllTagsHandler {
            return queryAllTagsHandler()
        }
        fatalError("queryAllTagsHandler returns can't have a default value thus its handler must be set")
    }
}

public class TsundocCommandServiceMock: TsundocCommandService {
    public init() { }

    public private(set) var performCallCount = 0
    public var performHandler: ((@escaping () -> Void) -> Void)?
    public func perform(_ block: @escaping () -> Void) {
        performCallCount += 1
        if let performHandler = performHandler {
            performHandler(block)
        }
    }

    public private(set) var createTsundocCallCount = 0
    public var createTsundocHandler: ((TsundocCommand) -> (Result<Tsundoc.ID, CommandServiceError>))?
    public func createTsundoc(by command: TsundocCommand) -> Result<Tsundoc.ID, CommandServiceError> {
        createTsundocCallCount += 1
        if let createTsundocHandler = createTsundocHandler {
            return createTsundocHandler(command)
        }
        fatalError("createTsundocHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var performBlockCallCount = 0
    public var performBlockHandler: ((@escaping () throws -> Any) throws -> (Any))?
    public func perform<T>(_ block: @escaping () throws -> T) throws -> T {
        performBlockCallCount += 1
        if let performBlockHandler = performBlockHandler {
            return try performBlockHandler(block) as! T
        }
        fatalError("performBlockHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var updateTsundocCallCount = 0
    public var updateTsundocHandler: ((Tsundoc.ID, String) -> (Result<Void, CommandServiceError>))?
    public func updateTsundoc(having id: Tsundoc.ID, title: String) -> Result<Void, CommandServiceError> {
        updateTsundocCallCount += 1
        if let updateTsundocHandler = updateTsundocHandler {
            return updateTsundocHandler(id, title)
        }
        fatalError("updateTsundocHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var beginCallCount = 0
    public var beginHandler: (() throws -> Void)?
    public func begin() throws {
        beginCallCount += 1
        if let beginHandler = beginHandler {
            try beginHandler()
        }
    }

    public private(set) var commitCallCount = 0
    public var commitHandler: (() throws -> Void)?
    public func commit() throws {
        commitCallCount += 1
        if let commitHandler = commitHandler {
            try commitHandler()
        }
    }

    public private(set) var cancelCallCount = 0
    public var cancelHandler: (() throws -> Void)?
    public func cancel() throws {
        cancelCallCount += 1
        if let cancelHandler = cancelHandler {
            try cancelHandler()
        }
    }

    public private(set) var updateTsundocHavingCallCount = 0
    public var updateTsundocHavingHandler: ((Tsundoc.ID, String?, EmojiBackgroundColor?) -> (Result<Void, CommandServiceError>))?
    public func updateTsundoc(having id: Tsundoc.ID, emojiAlias: String?, emojiBackgroundColor: EmojiBackgroundColor?) -> Result<Void, CommandServiceError> {
        updateTsundocHavingCallCount += 1
        if let updateTsundocHavingHandler = updateTsundocHavingHandler {
            return updateTsundocHavingHandler(id, emojiAlias, emojiBackgroundColor)
        }
        fatalError("updateTsundocHavingHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var updateTsundocHavingIsUnreadCallCount = 0
    public var updateTsundocHavingIsUnreadHandler: ((Tsundoc.ID, Bool) -> (Result<Void, CommandServiceError>))?
    public func updateTsundoc(having id: Tsundoc.ID, isUnread: Bool) -> Result<Void, CommandServiceError> {
        updateTsundocHavingIsUnreadCallCount += 1
        if let updateTsundocHavingIsUnreadHandler = updateTsundocHavingIsUnreadHandler {
            return updateTsundocHavingIsUnreadHandler(id, isUnread)
        }
        fatalError("updateTsundocHavingIsUnreadHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var updateTsundocHavingByAddingTagHavingCallCount = 0
    public var updateTsundocHavingByAddingTagHavingHandler: ((Tsundoc.ID, Tag.ID) -> (Result<Void, CommandServiceError>))?
    public func updateTsundoc(having id: Tsundoc.ID, byAddingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError> {
        updateTsundocHavingByAddingTagHavingCallCount += 1
        if let updateTsundocHavingByAddingTagHavingHandler = updateTsundocHavingByAddingTagHavingHandler {
            return updateTsundocHavingByAddingTagHavingHandler(id, tagId)
        }
        fatalError("updateTsundocHavingByAddingTagHavingHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var updateTsundocHavingByRemovingTagHavingCallCount = 0
    public var updateTsundocHavingByRemovingTagHavingHandler: ((Tsundoc.ID, Tag.ID) -> (Result<Void, CommandServiceError>))?
    public func updateTsundoc(having id: Tsundoc.ID, byRemovingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError> {
        updateTsundocHavingByRemovingTagHavingCallCount += 1
        if let updateTsundocHavingByRemovingTagHavingHandler = updateTsundocHavingByRemovingTagHavingHandler {
            return updateTsundocHavingByRemovingTagHavingHandler(id, tagId)
        }
        fatalError("updateTsundocHavingByRemovingTagHavingHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var updateTsundocHavingByReplacingTagsHavingCallCount = 0
    public var updateTsundocHavingByReplacingTagsHavingHandler: ((Tsundoc.ID, Set<Tag.ID>) -> (Result<Void, CommandServiceError>))?
    public func updateTsundoc(having id: Tsundoc.ID, byReplacingTagsHaving tagIds: Set<Tag.ID>) -> Result<Void, CommandServiceError> {
        updateTsundocHavingByReplacingTagsHavingCallCount += 1
        if let updateTsundocHavingByReplacingTagsHavingHandler = updateTsundocHavingByReplacingTagsHavingHandler {
            return updateTsundocHavingByReplacingTagsHavingHandler(id, tagIds)
        }
        fatalError("updateTsundocHavingByReplacingTagsHavingHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var deleteTsundocCallCount = 0
    public var deleteTsundocHandler: ((Tsundoc.ID) -> (Result<Void, CommandServiceError>))?
    public func deleteTsundoc(having id: Tsundoc.ID) -> Result<Void, CommandServiceError> {
        deleteTsundocCallCount += 1
        if let deleteTsundocHandler = deleteTsundocHandler {
            return deleteTsundocHandler(id)
        }
        fatalError("deleteTsundocHandler returns can't have a default value thus its handler must be set")
    }
}

public class TsundocQueryServiceMock: TsundocQueryService {
    public init() { }

    public private(set) var queryTsundocCallCount = 0
    public var queryTsundocHandler: ((Tsundoc.ID) -> (Result<AnyObservedEntity<Tsundoc>, QueryServiceError>))?
    public func queryTsundoc(having id: Tsundoc.ID) -> Result<AnyObservedEntity<Tsundoc>, QueryServiceError> {
        queryTsundocCallCount += 1
        if let queryTsundocHandler = queryTsundocHandler {
            return queryTsundocHandler(id)
        }
        fatalError("queryTsundocHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var queryTsundocsCallCount = 0
    public var queryTsundocsHandler: ((Tag.ID) -> (Result<AnyObservedEntityArray<Tsundoc>, QueryServiceError>))?
    public func queryTsundocs(tagged tagId: Tag.ID) -> Result<AnyObservedEntityArray<Tsundoc>, QueryServiceError> {
        queryTsundocsCallCount += 1
        if let queryTsundocsHandler = queryTsundocsHandler {
            return queryTsundocsHandler(tagId)
        }
        fatalError("queryTsundocsHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var queryAllTsundocsCallCount = 0
    public var queryAllTsundocsHandler: (() -> (Result<AnyObservedEntityArray<Tsundoc>, QueryServiceError>))?
    public func queryAllTsundocs() -> Result<AnyObservedEntityArray<Tsundoc>, QueryServiceError> {
        queryAllTsundocsCallCount += 1
        if let queryAllTsundocsHandler = queryAllTsundocsHandler {
            return queryAllTsundocsHandler()
        }
        fatalError("queryAllTsundocsHandler returns can't have a default value thus its handler must be set")
    }
}

public class ObservedEntityArrayMock: ObservedEntityArray {
    public init() { }
    public init(values: CurrentValueSubject<[Entity], Error>) {
        self._values = values
    }

    public typealias Entity = Any

    public private(set) var valuesSetCallCount = 0
    private var _values: CurrentValueSubject<[Entity], Error>! { didSet { valuesSetCallCount += 1 } }
    public var values: CurrentValueSubject<[Entity], Error> {
        get { return _values }
        set { _values = newValue }
    }
}

public class ObservedEntityMock: ObservedEntity {
    public init() { }
    public init(value: CurrentValueSubject<Entity, Error>) {
        self._value = value
    }

    public typealias Entity = Any

    public private(set) var valueSetCallCount = 0
    private var _value: CurrentValueSubject<Entity, Error>! { didSet { valueSetCallCount += 1 } }
    public var value: CurrentValueSubject<Entity, Error> {
        get { return _value }
        set { _value = newValue }
    }
}

public class WebPageMetaResolvableMock: WebPageMetaResolvable {
    public init() { }

    public private(set) var resolveCallCount = 0
    public var resolveHandler: ((URL) throws -> (WebPageMeta))?
    public func resolve(from url: URL) throws -> WebPageMeta {
        resolveCallCount += 1
        if let resolveHandler = resolveHandler {
            return try resolveHandler(url)
        }
        fatalError("resolveHandler returns can't have a default value thus its handler must be set")
    }
}

public class SharedUrlLoadableMock: SharedUrlLoadable {
    public init() { }

    public private(set) var loadCallCount = 0
    public var loadHandler: ((@escaping (URL?) -> Void) -> Void)?
    public func load(_ completion: @escaping (URL?) -> Void) {
        loadCallCount += 1
        if let loadHandler = loadHandler {
            loadHandler(completion)
        }
    }
}

public class HasTsundocQueryServiceMock: HasTsundocQueryService {
    public init() { }
    public init(tsundocQueryService: TsundocQueryService = TsundocQueryServiceMock()) {
        self.tsundocQueryService = tsundocQueryService
    }

    public private(set) var tsundocQueryServiceSetCallCount = 0
    public var tsundocQueryService: TsundocQueryService = TsundocQueryServiceMock() { didSet { tsundocQueryServiceSetCallCount += 1 } }
}

public class HasTagQueryServiceMock: HasTagQueryService {
    public init() { }
    public init(tagQueryService: TagQueryService = TagQueryServiceMock()) {
        self.tagQueryService = tagQueryService
    }

    public private(set) var tagQueryServiceSetCallCount = 0
    public var tagQueryService: TagQueryService = TagQueryServiceMock() { didSet { tagQueryServiceSetCallCount += 1 } }
}

public class HasTsundocCommandServiceMock: HasTsundocCommandService {
    public init() { }
    public init(tsundocCommandService: TsundocCommandService = TsundocCommandServiceMock()) {
        self.tsundocCommandService = tsundocCommandService
    }

    public private(set) var tsundocCommandServiceSetCallCount = 0
    public var tsundocCommandService: TsundocCommandService = TsundocCommandServiceMock() { didSet { tsundocCommandServiceSetCallCount += 1 } }
}

public class HasTagCommandServiceMock: HasTagCommandService {
    public init() { }
    public init(tagCommandService: TagCommandService = TagCommandServiceMock()) {
        self.tagCommandService = tagCommandService
    }

    public private(set) var tagCommandServiceSetCallCount = 0
    public var tagCommandService: TagCommandService = TagCommandServiceMock() { didSet { tagCommandServiceSetCallCount += 1 } }
}

public class HasSharedUrlLoaderMock: HasSharedUrlLoader {
    public init() { }
    public init(sharedUrlLoader: SharedUrlLoadable = SharedUrlLoadableMock()) {
        self.sharedUrlLoader = sharedUrlLoader
    }

    public private(set) var sharedUrlLoaderSetCallCount = 0
    public var sharedUrlLoader: SharedUrlLoadable = SharedUrlLoadableMock() { didSet { sharedUrlLoaderSetCallCount += 1 } }
}

public class HasWebPageMetaResolverMock: HasWebPageMetaResolver {
    public init() { }
    public init(webPageMetaResolver: WebPageMetaResolvable = WebPageMetaResolvableMock()) {
        self.webPageMetaResolver = webPageMetaResolver
    }

    public private(set) var webPageMetaResolverSetCallCount = 0
    public var webPageMetaResolver: WebPageMetaResolvable = WebPageMetaResolvableMock() { didSet { webPageMetaResolverSetCallCount += 1 } }
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
