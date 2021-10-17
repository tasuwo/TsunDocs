//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

public struct SearchableFilterState<Item: Searchable>: Equatable {
    public var items: [Item]
    public var filteredIds: Set<Item.ID>

    var lastHandledQuery: String?
    var storage: SearchableStorage<Item> = .init()

    public var filteredItems: [Item] {
        items.filter { filteredIds.contains($0.id) }
    }

    public init(items: [Item]) {
        self.items = items
        self.filteredIds = Set(items.map(\.id))
    }
}
