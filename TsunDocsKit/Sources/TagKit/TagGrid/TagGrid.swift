//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI
import TextEditAlert

public struct TagGrid: View {
    // MARK: - Properties

    @Binding private var tags: [Tag]
    @Binding private var selectedIds: Set<Tag.ID>

    @State private var availableWidth: CGFloat = 0
    @State private var cellSizes: [Tag: CGSize] = [:]
    @State private var isDeleteConfirmationPresenting = false
    @State private var renamingTag: Tag? = nil

    @Namespace var animation
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    private let configuration: Configuration
    private let spacing: CGFloat
    private let inset: CGFloat
    private let onPerform: ((Action) -> Void)?

    // MARK: - Initializers

    public init(tags: Binding<[Tag]>,
                selectedIds: Binding<Set<Tag.ID>>,
                configuration: Configuration = .init(.default),
                spacing: CGFloat = 8,
                inset: CGFloat = 8,
                onPerform: ((Action) -> Void)? = nil)
    {
        _tags = tags
        _selectedIds = selectedIds
        self.configuration = configuration
        self.spacing = spacing
        self.inset = inset
        self.onPerform = onPerform
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            Color.clear
                .frame(height: 0)
                .onChangeFrame { frame in
                    cellSizes = [:]
                    availableWidth = frame.width
                }

            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    Color.clear
                        .frame(height: 0)
                        .frame(minWidth: 0, maxWidth: .infinity)

                    ForEach(calcRows(), id: \.self) { tags in
                        HStack(spacing: spacing) {
                            ForEach(tags) {
                                cell($0)
                            }
                        }
                    }
                }
                .padding(.all, inset)
            }
        }
        .onChange(of: dynamicTypeSize) { _ in
            cellSizes = [:]
        }
        .alert(
            isPresenting: .init {
                renamingTag != nil
            } set: { isPresenting in
                guard !isPresenting else { return }
                renamingTag = nil
            },
            text: renamingTag?.name ?? "",
            config: .init(title: NSLocalizedString("tag_grid_alert_rename_tag_title", bundle: Bundle.module, comment: ""),
                          message: NSLocalizedString("tag_grid_alert_rename_tag_message", bundle: Bundle.module, comment: ""),
                          placeholder: NSLocalizedString("tag_grid_alert_rename_tag_placeholder", bundle: Bundle.module, comment: ""),
                          validator: { _ in return true },
                          saveAction: { text in
                              guard let tag = renamingTag else { return }
                              renamingTag = nil
                              onPerform?(.rename(tagId: tag.id, name: text))
                          },
                          cancelAction: nil)
        )
    }

    private func cell(_ tag: Tag) -> some View {
        return TagCell(
            id: tag.id,
            name: tag.name,
            count: tag.count,
            status: .init(configuration, isSelected: selectedIds.contains(tag.id)),
            size: configuration.size
        ) {
            switch $0 {
            case let .select(tagId):
                onPerform?(.select(tagId: tagId))

            case let .delete(tagId):
                onPerform?(.delete(tagId: tagId))
            }
        }
        .contextMenu {
            menu(tag)
        }
        .confirmationDialog(
            Text("tag_grid_alert_delete_tag_message \(tag.name)", bundle: Bundle.module),
            isPresented: $isDeleteConfirmationPresenting,
            titleVisibility: .visible
        ) {
            deleteConfirmationDialog(tag)
        }
        .matchedGeometryEffect(id: tag.id, in: animation)
    }

    @ViewBuilder
    private func menu(_ tag: Tag) -> some View {
        if configuration.isEnabledMenu {
            Button {
                onPerform?(.copy(tagId: tag.id))
            } label: {
                Label {
                    Text("tag_grid_menu_copy", bundle: Bundle.module)
                } icon: {
                    Image(systemName: "doc.on.doc")
                }
            }

            Button {
                renamingTag = tag
            } label: {
                Label {
                    Text("tag_grid_menu_rename", bundle: Bundle.module)
                } icon: {
                    Image(systemName: "text.cursor")
                }
            }

            Divider()

            Button(role: .destructive) {
                isDeleteConfirmationPresenting = true
            } label: {
                Label {
                    Text("tag_grid_menu_delete", bundle: Bundle.module)
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
        Button(role: .destructive) {
            onPerform?(.delete(tagId: tag.id))
        } label: {
            Text("tag_grid_alert_delete_tag_action", bundle: Bundle.module)
        }
        Button(role: .cancel, action: {}, label: { Text("cancel", bundle: Bundle.module) })
    }

    private func calcRows() -> [[Tag]] {
        var rows: [[Tag]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth - inset * 2

        for tag in tags {
            let cellSize: CGSize
            if let size = cellSizes[tag] {
                cellSize = size
            } else {
                let size = TagCell.preferredSize(name: tag.name,
                                                 count: tag.count,
                                                 size: configuration.size,
                                                 isDeletable: configuration.style == .deletable)
                let width = min(size.width, availableWidth - inset * 2)
                cellSize = CGSize(width: width, height: size.height)
            }

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

private extension TagCell.Status {
    init(_ config: TagGrid.Configuration, isSelected: Bool) {
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
    struct ContentView: View {
        // MARK: - Properties

        @State private var tags: [Tag]
        @State private var selectedIds: Set<Tag.ID> = .init()

        // MARK: - Initializers

        init(tags: [Tag]) {
            self.tags = tags
        }

        // MARK: - View

        public var body: some View {
            VStack {
                Button {
                    withAnimation {
                        tags.insert(Tag(id: UUID(), name: "Added"), at: 0)
                    }
                } label: {
                    Text("Add Tag")
                }

                TagGrid(tags: $tags,
                        selectedIds: $selectedIds,
                        configuration: .init(.selectable(.multiple), isEnabledMenu: true)) { action in
                    switch action {
                    case let .select(tagId):
                        if selectedIds.contains(tagId) {
                            selectedIds.subtract([tagId])
                        } else {
                            selectedIds = selectedIds.union([tagId])
                        }

                    case let .delete(tagId):
                        guard let index = tags.firstIndex(where: { $0.id == tagId }) else { return }
                        _ = withAnimation {
                            tags.remove(at: index)
                        }

                    case .copy:
                        break

                    case let .rename(tagId, name):
                        guard let index = self.tags.firstIndex(where: { $0.id == tagId }) else { return }
                        withAnimation {
                            var tag = self.tags[index]
                            tag.name = name
                            self.tags[index] = tag
                        }
                    }
                }
            }
        }
    }

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
        ContentView(tags: tags)
    }
}
