//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TagGrid: View {
    // MARK: - Properties

    @ObservedObject var store: ViewStore<TagGridState, TagGridAction, TagGridDependency>

    @State private var availableWidth: CGFloat = 0
    @State private var cellSizes: [Tag: CGSize] = [:]

    private let spacing: CGFloat
    private let inset: CGFloat

    // MARK: - Initializers

    public init(store: ViewStore<TagGridState, TagGridAction, TagGridDependency>,
                spacing: CGFloat = 8,
                inset: CGFloat = 8)
    {
        _store = ObservedObject(wrappedValue: store)
        self.spacing = spacing
        self.inset = inset
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            Color.clear
                .frame(height: 0)
                .onChangeFrame {
                    availableWidth = $0.width
                }

            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: spacing) {
                        ForEach(calcRows(), id: \.self) { tags in
                            HStack(spacing: spacing) {
                                ForEach(tags) { cell(geometry, $0) }
                            }
                        }
                    }
                    .padding(.all, inset)
                }
            }
        }
    }

    private func cell(_ geometry: GeometryProxy, _ tag: Tag) -> some View {
        return TagCell(
            tagId: tag.id,
            tagName: tag.name,
            status: .init(store.state.configuration,
                          isSelected: store.state.selectedIds.contains(tag.id)),
            size: store.state.configuration.size,
            onSelect: { store.execute(.selected($0)) },
            onDelete: { store.execute(.deleted($0), animation: .default) }
        )
        .frame(maxWidth: geometry.size.width - inset * 2)
        .fixedSize()
        .onChangeFrame {
            cellSizes[tag] = $0
        }
    }

    private func calcRows() -> [[Tag]] {
        var rows: [[Tag]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth - inset * 2

        for tag in store.state.tags {
            let cellSize = cellSizes[tag, default: CGSize(width: availableWidth - inset * 2, height: 1)]

            if remainingWidth - (cellSize.width + spacing) >= 0 {
                rows[currentRow].append(tag)
            } else {
                currentRow += 1
                rows.append([tag])
                remainingWidth = availableWidth - inset * 2
            }

            remainingWidth -= (cellSize.width + spacing)
        }

        return rows
    }
}

private extension TagCellStatus {
    init(_ config: TagGridConfiguration, isSelected: Bool) {
        switch config.style {
        case .selectable:
            self = isSelected ? .selected : .default

        case .deletable:
            self = .deletable

        default:
            self = .default
        }
    }
}

// MARK: - Preview

struct TagGrid_Previews: PreviewProvider {
    class Dependency: HasNop {}

    static let tags: [Tag] = [
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

    static var previews: some View {
        Group {
            TagGrid(store: makeViewStore(.init(.default)))

            VStack(alignment: .center, spacing: 4) {
                TagGrid(store: makeViewStore(.init(.default)))

                TagGrid(store: makeViewStore(.init(.selectable(.multiple))))

                TagGrid(store: makeViewStore(.init(.selectable(.single))))

                TagGrid(store: makeViewStore(.init(.deletable)))
            }

            VStack(spacing: 4) {
                TagGrid(store: makeViewStore(.init(.default, size: .small)))

                TagGrid(store: makeViewStore(.init(.selectable(.multiple), size: .small)))

                TagGrid(store: makeViewStore(.init(.selectable(.single), size: .small)))

                TagGrid(store: makeViewStore(.init(.deletable, size: .small)))
            }
        }
    }

    static func makeViewStore(_ config: TagGridConfiguration) -> ViewStore<TagGridState, TagGridAction, TagGridDependency>
    {
        let store = Store(initialState: TagGridState(tags: tags,
                                                     configuration: config),
                          dependency: Dependency(),
                          reducer: TagGridReducer())
        return ViewStore(store: store)
    }
}
