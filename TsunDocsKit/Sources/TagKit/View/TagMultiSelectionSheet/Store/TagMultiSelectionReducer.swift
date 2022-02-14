//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain

public typealias TagMultiSelectionDependency = HasTagCommandService
    & HasTagQueryService

public struct TagMultiSelectionReducer: Reducer {
    public typealias Dependency = TagMultiSelectionDependency
    public typealias State = TagMultiSelectionState
    public typealias Action = TagMultiSelectionAction

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

        case let .updatedSelectedTags(tagIds):
            nextState.selectedIds = tagIds
            return (nextState, .none)

        case let .createNewTag(tagName):
            let effect = Effect<Action> {
                do {
                    let tagId = try await dependency.tagCommandService.createTag(by: .init(name: tagName))
                    return .createdNewTag(tagId)
                } catch let error as CommandServiceError {
                    return .failedToCreateTag(error)
                } catch {
                    return .failedToCreateTag(nil)
                }
            }
            return (nextState, [effect])

        case let .createdNewTag(tagId):
            nextState.selectedIds = nextState.selectedIds.union([tagId])
            return (nextState, .none)

        case .failedToCreateTag:
            nextState.alert = .failedToCreateTag
            return (nextState, .none)

        case .alertDismissed:
            nextState.alert = nil
            return (nextState, .none)
        }
    }
}

// MARK: - Preparation

extension TagMultiSelectionReducer {
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
        let tagsEffect = AnimatingEffect(tagsStream, underlying: entities, animateWith: .default)

        nextState.tags = entities.values.value

        return (nextState, [tagsEffect])
    }
}

// MARK: - Preview

#if DEBUG

import Foundation
import PreviewContent

public class TagMultiSelectionDependencyMock: TagMultiSelectionDependency {
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
        service.performBlockHandler = { try $0() }
        service.beginHandler = {}
        service.commitHandler = {}
        service.createTagHandler = { [unowned self] command in
            let id = UUID()
            let newTag = Tag(id: id,
                             name: command.name,
                             tsundocsCount: 0)

            let values = self.tags.values.value
            self.tags.values.send([newTag] + values)

            return .success(id)
        }
        service.updateTagHandler = { id, name in
            var snapshot = self.tags.values.value
            guard let index = snapshot.firstIndex(where: { $0.id == id }) else { return .failure(.notFound) }
            snapshot[index] = .init(id: snapshot[index].id, name: name)
            self.tags.values.send(snapshot)
            return .success(())
        }
        service.deleteTagHandler = { id in
            var snapshot = self.tags.values.value
            guard let index = snapshot.firstIndex(where: { $0.id == id }) else { return .failure(.notFound) }
            snapshot.remove(at: index)
            self.tags.values.send(snapshot)
            return .success(())
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
