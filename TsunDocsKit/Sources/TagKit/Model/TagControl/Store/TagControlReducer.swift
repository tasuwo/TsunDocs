//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias TagControlDependency = HasTagCommandService
    & HasTagQueryService

public struct TagControlReducer: Reducer {
    public typealias Dependency = TagControlDependency
    public typealias State = TagControlState
    public typealias Action = TagControlAction

    // MARK: - Initializer

    public init() {}

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state
        switch action {
        case .onAppear:
            return Self.prepareQueryEffects(nextState, dependency)

        case let .updatedTags(tags):
            nextState.tags = tags
            return (nextState, .none)

        case let .createNewTag(tagName):
            let effect = Effect<Action> {
                do {
                    try await dependency.tagCommandService.createTag(by: .init(name: tagName))
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToCreateTag(error)
                } catch {
                    return .failedToCreateTag(nil)
                }
            }
            return (nextState, [effect])

        case let .deleteTag(tagId):
            let effect = Effect<Action> {
                do {
                    try await dependency.tagCommandService.deleteTag(having: tagId)
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToDeleteTag(error)
                } catch {
                    return .failedToDeleteTag(nil)
                }
            }
            return (nextState, [effect])

        case let .renameTag(tagId, name: newName):
            let effect = Effect<Action> {
                do {
                    try await dependency.tagCommandService.updateTag(having: tagId, nameTo: newName)
                    return .none
                } catch let error as CommandServiceError {
                    return .failedToRenameTag(error)
                } catch {
                    return .failedToRenameTag(nil)
                }
            }
            return (nextState, [effect])

        case .failedToCreateTag:
            nextState.alert = .failedToCreateTag
            return (nextState, .none)

        case .failedToDeleteTag:
            nextState.alert = .failedToDeleteTag
            return (nextState, .none)

        case .failedToRenameTag:
            nextState.alert = .failedToRenameTag
            return (nextState, .none)

        case .alertDismissed:
            nextState.alert = nil
            return (nextState, .none)
        }
    }
}

// MARK: - Preparation

extension TagControlReducer {
    private static func prepareQueryEffects(_ state: State, _ dependency: Dependency) -> (State, [Effect<Action>]) {
        var nextState = state

        let entities: AnyObservedEntityArray<Tag>
        switch dependency.tagQueryService.queryAllTags() {
        case let .success(result):
            entities = result

        case .failure:
            fatalError("Failed to load entities.")
        }

        let tagsStream = entities.values
            .catch { _ in Just([]) }
            .map { Action.updatedTags($0) as Action? }
        let tagsEffect = Effect(tagsStream, underlying: entities)

        nextState.tags = entities.values.value

        return (nextState, [tagsEffect])
    }
}

// MARK: - Preview

#if DEBUG

import Foundation
import PreviewContent

public class TagControlDependencyMock: TagControlDependency {
    var tags: AnyObservedEntityArray<Tag> = {
        let tags: [Tag] = [
            .init(id: UUID(), name: "This"),
            .init(id: UUID(), name: "is"),
            .init(id: UUID(), name: "Flexible"),
            .init(id: UUID(), name: "Gird"),
            .init(id: UUID(), name: "Layout"),
            .init(id: UUID(), name: "for"),
            .init(id: UUID(), name: "Tags."),
            .init(id: UUID(), name: "This"),
            .init(id: UUID(), name: "Layout"),
            .init(id: UUID(), name: "allows"),
            .init(id: UUID(), name: "displaying"),
            .init(id: UUID(), name: "very"),
            .init(id: UUID(), name: "long"),
            .init(id: UUID(), name: "tag"),
            .init(id: UUID(), name: "names"),
            .init(id: UUID(), name: "like"),
            .init(id: UUID(), name: "Too Too Too Too Long Tag"),
            .init(id: UUID(), name: "or"),
            .init(id: UUID(), name: "Toooooooooooooo Loooooooooooooooooooooooong Tag."),
            .init(id: UUID(), name: "All"),
            .init(id: UUID(), name: "cell"),
            .init(id: UUID(), name: "sizes"),
            .init(id: UUID(), name: "are"),
            .init(id: UUID(), name: "flexible")
        ]
        return ObservedTagArrayMock(values: .init(tags))
            .eraseToAnyObservedEntityArray()
    }()

    public var tagCommandService: TagCommandService {
        let service = TagCommandServiceMock()
        service.performHandler = { $0() }
        service.beginHandler = {}
        service.commitHandler = {}
        service.createTagHandler = { [unowned self] _ in
            let id = UUID()
            let newTag = Tag(id: id,
                             name: String(UUID().uuidString.prefix(5)),
                             tsundocsCount: 5)

            let values = self.tags.values.value
            self.tags.values.send(values + [newTag])

            return .success(id)
        }
        return service
    }

    public var tagQueryService: TagQueryService {
        let service = TagQueryServiceMock()
        service.queryAllTagsHandler = { [unowned self] in
            .success(self.tags)
        }
        return service
    }

    public init() {}
}

#endif
