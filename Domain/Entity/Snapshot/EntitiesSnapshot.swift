//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public struct EntitiesSnapshot<Entity: Identifiable & Hashable>: Equatable {
    private let _entities: [Entity.ID: Ordered<Entity>]
    private let _selectedIds: Set<Entity.ID>
    private let _filteredIds: Set<Entity.ID>

    // MARK: - Initializers

    public init(_ entities: [Entity]) {
        _entities = entities.indexed()
        _selectedIds = .init()
        _filteredIds = Set(entities.map(\.id))
    }

    public init(entities: [Entity.ID: Ordered<Entity>] = [:],
                selectedIds: Set<Entity.ID> = .init(),
                filteredIds: Set<Entity.ID> = .init())
    {
        _entities = entities
        _selectedIds = selectedIds
        _filteredIds = filteredIds
    }
}

// MARK: - Write

public extension EntitiesSnapshot {
    func updating(entities: [Entity]) -> Self {
        return .init(entities: entities.indexed(),
                     selectedIds: _selectedIds,
                     filteredIds: _filteredIds)
    }

    func updating(selectedIds: Set<Entity.ID>) -> Self {
        return .init(entities: _entities,
                     selectedIds: selectedIds,
                     filteredIds: _filteredIds)
    }

    func selecting(id: Entity.ID) -> Self {
        return .init(entities: _entities,
                     selectedIds: _selectedIds.union(Set([id])),
                     filteredIds: _filteredIds)
    }

    func deselecting(id: Entity.ID) -> Self {
        return .init(entities: _entities,
                     selectedIds: _selectedIds.subtracting(Set([id])),
                     filteredIds: _filteredIds)
    }

    func updating(filteredIds: Set<Entity.ID>) -> Self {
        return .init(entities: _entities,
                     selectedIds: _selectedIds,
                     filteredIds: filteredIds)
    }

    func removingEntity(having id: Entity.ID) -> Self {
        let newEntities = _entities.values
            .sorted(by: { $0.index < $1.index })
            .map(\.value)
            .filter { $0.id != id }
            .indexed()

        return .init(entities: newEntities,
                     selectedIds: _selectedIds,
                     filteredIds: _filteredIds)
    }
}

// MARK: - Read

public extension EntitiesSnapshot {
    func entity(having id: Entity.ID) -> Entity? {
        return _entities[id]?.value
    }

    func orderedEntities() -> [Entity] {
        _entities
            .map(\.value)
            .sorted(by: { $0.index < $1.index })
            .map(\.value)
    }

    func selectedIds() -> Set<Entity.ID> {
        _selectedIds
            .intersection(Set(_entities.keys))
    }

    func selectedEntities() -> Set<Entity> {
        Set(_selectedIds.compactMap { _entities[$0]?.value })
    }

    func selectedOrderedEntities() -> Set<Ordered<Entity>> {
        Set(_selectedIds.compactMap { _entities[$0] })
    }

    func orderedSelectedEntities() -> [Entity] {
        _selectedIds
            .compactMap { _entities[$0] }
            .sorted(by: { $0.index < $1.index })
            .map(\.value)
    }

    func filteredEntity(having id: Entity.ID) -> Entity? {
        guard _filteredIds.contains(id) else { return nil }
        return _entities[id]?.value
    }

    func filteredIds() -> Set<Entity.ID> {
        _filteredIds
            .intersection(Set(_entities.keys))
    }

    func filteredEntities() -> Set<Entity> {
        Set(_filteredIds.compactMap { _entities[$0]?.value })
    }

    func filteredOrderedEntities() -> Set<Ordered<Entity>> {
        Set(_filteredIds.compactMap { _entities[$0] })
    }

    func orderedFilteredEntities() -> [Entity] {
        _filteredIds
            .compactMap { _entities[$0] }
            .sorted(by: { $0.index < $1.index })
            .map(\.value)
    }
}
