///
/// @Generated by Mockolo
///

import Combine
import CoreData
import Domain

public class HasImageLoaderMock: HasImageLoader {
    public init() { }
    public init(imageLoader: ImageLoader) {
        self._imageLoader = imageLoader
    }

    public private(set) var imageLoaderSetCallCount = 0
    private var _imageLoader: ImageLoader! { didSet { imageLoaderSetCallCount += 1 } }
    public var imageLoader: ImageLoader {
        get { return _imageLoader }
        set { _imageLoader = newValue }
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

    public private(set) var updateTagCallCount = 0
    public var updateTagHandler: ((Tag.ID, String) -> (Result<Void, CommandServiceError>))?
    public func updateTag(having id: Tag.ID, nameTo name: String) -> Result<Void, CommandServiceError> {
        updateTagCallCount += 1
        if let updateTagHandler = updateTagHandler {
            return updateTagHandler(id, name)
        }
        fatalError("updateTagHandler returns can't have a default value thus its handler must be set")
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

    public private(set) var queryTagCallCount = 0
    public var queryTagHandler: ((Tag.ID) -> (Result<AnyObservedEntity<Tag>, QueryServiceError>))?
    public func queryTag(having id: Tag.ID) -> Result<AnyObservedEntity<Tag>, QueryServiceError> {
        queryTagCallCount += 1
        if let queryTagHandler = queryTagHandler {
            return queryTagHandler(id)
        }
        fatalError("queryTagHandler returns can't have a default value thus its handler must be set")
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

    public private(set) var updateTsundocCallCount = 0
    public var updateTsundocHandler: ((Tsundoc.ID, Tag.ID) -> (Result<Void, CommandServiceError>))?
    public func updateTsundoc(having id: Tsundoc.ID, byAddingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError> {
        updateTsundocCallCount += 1
        if let updateTsundocHandler = updateTsundocHandler {
            return updateTsundocHandler(id, tagId)
        }
        fatalError("updateTsundocHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var updateTsundocHavingCallCount = 0
    public var updateTsundocHavingHandler: ((Tsundoc.ID, Tag.ID) -> (Result<Void, CommandServiceError>))?
    public func updateTsundoc(having id: Tsundoc.ID, byRemovingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError> {
        updateTsundocHavingCallCount += 1
        if let updateTsundocHavingHandler = updateTsundocHavingHandler {
            return updateTsundocHavingHandler(id, tagId)
        }
        fatalError("updateTsundocHavingHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var updateTsundocHavingByReplacingTagsHavingCallCount = 0
    public var updateTsundocHavingByReplacingTagsHavingHandler: ((Tsundoc.ID, Set<Tag.ID>) -> (Result<Void, CommandServiceError>))?
    public func updateTsundoc(having id: Tsundoc.ID, byReplacingTagsHaving tagID: Set<Tag.ID>) -> Result<Void, CommandServiceError> {
        updateTsundocHavingByReplacingTagsHavingCallCount += 1
        if let updateTsundocHavingByReplacingTagsHavingHandler = updateTsundocHavingByReplacingTagsHavingHandler {
            return updateTsundocHavingByReplacingTagsHavingHandler(id, tagID)
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
