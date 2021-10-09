//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TagGrid: View {
    // MARK: - Properties

    @StateObject var store: ViewStore<TagGridState, TagGridAction, TagGridDependency>

    @State private var availableWidth: CGFloat = 0
    @State private var cellSizes: [Tag: CGSize] = [:]

    private let spacing: CGFloat
    private let inset: CGFloat

    // MARK: - Initializers

    public init(store: ViewStore<TagGridState, TagGridAction, TagGridDependency>,
                spacing: CGFloat = 8,
                inset: CGFloat = 8)
    {
        _store = StateObject(wrappedValue: store)
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
                        Color.clear
                            .frame(height: 0)
                            .frame(minWidth: 0, maxWidth: .infinity)

                        ForEach(calcRows(), id: \.self) { tags in
                            HStack(spacing: spacing) {
                                ForEach(tags) {
                                    cell(geometry, $0)
                                }
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
            tsundocCount: tag.tsundocsCount,
            status: .init(store.state.configuration,
                          isSelected: store.state.selectedIds.contains(tag.id)),
            size: store.state.configuration.size,
            onSelect: { store.execute(.select($0)) },
            onDelete: { store.execute(.delete($0), animation: .default) }
        )
        .frame(maxWidth: geometry.size.width - inset * 2)
        .fixedSize()
        .onChangeFrame {
            cellSizes[tag] = $0
        }
        .contextMenu {
            menu(tag)
        }
        .confirmationDialog(
            Text(store.state.titleForConfirmationToDelete),
            isPresented: store.bind {
                $0.deletingTagId == tag.id
            } action: { _ in
                .alert(.dismissed)
            },
            titleVisibility: .visible
        ) {
            deleteConfirmationDialog(tag)
        }
    }

    @ViewBuilder
    private func menu(_ tag: Tag) -> some View {
        if store.state.configuration.isEnabledMenu {
            Button {
                store.execute(.tap(tag.id, .copy))
            } label: {
                Label {
                    Text(L10n.tagGridMenuCopy)
                } icon: {
                    Image(systemName: "doc.on.doc")
                }
            }

            Button {
                store.execute(.tap(tag.id, .rename))
            } label: {
                Label {
                    Text(L10n.tagGridMenuRename)
                } icon: {
                    Image(systemName: "text.cursor")
                }
            }

            Divider()

            Button(role: .destructive) {
                store.execute(.tap(tag.id, .delete))
            } label: {
                Label {
                    Text(L10n.tagGridMenuDelete)
                } icon: {
                    Image(systemName: "trash")
                }
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func deleteConfirmationDialog(_ tag: Tag) -> some View {
        Button(store.state.actionForConfirmationToDelete, role: .destructive) {
            store.execute(.alert(.confirmedToDelete(tag.id)))
        }

        Button(L10n.cancel, role: .cancel) {
            store.execute(.alert(.dismissed))
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

#if DEBUG
import PreviewContent
#endif

struct TagGrid_Previews: PreviewProvider {
    class Dependency: HasNop {}

    static let tags: [Tag] = [
        .makeDefault(id: UUID(), name: "This"),
        .makeDefault(id: UUID(), name: "is"),
        .makeDefault(id: UUID(), name: "Flexible"),
        .makeDefault(id: UUID(), name: "Gird"),
        .makeDefault(id: UUID(), name: "Layout"),
        .makeDefault(id: UUID(), name: "for"),
        .makeDefault(id: UUID(), name: "Tags."),
        .makeDefault(id: UUID(), name: "This"),
        .makeDefault(id: UUID(), name: "Layout"),
        .makeDefault(id: UUID(), name: "allows"),
        .makeDefault(id: UUID(), name: "displaying"),
        .makeDefault(id: UUID(), name: "very"),
        .makeDefault(id: UUID(), name: "long"),
        .makeDefault(id: UUID(), name: "tag"),
        .makeDefault(id: UUID(), name: "names"),
        .makeDefault(id: UUID(), name: "like"),
        .makeDefault(id: UUID(), name: "Too Too Too Too Long Tag"),
        .makeDefault(id: UUID(), name: "or"),
        .makeDefault(id: UUID(), name: "Toooooooooooooo Loooooooooooooooooooooooong Tag."),
        .makeDefault(id: UUID(), name: "All"),
        .makeDefault(id: UUID(), name: "cell"),
        .makeDefault(id: UUID(), name: "sizes"),
        .makeDefault(id: UUID(), name: "are"),
        .makeDefault(id: UUID(), name: "flexible")
    ]

    static var previews: some View {
        Group {
            TagGrid(store: makeViewStore(.init(.default, isEnabledMenu: true)))

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
