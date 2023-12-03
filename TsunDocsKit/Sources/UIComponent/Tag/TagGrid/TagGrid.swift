//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Tag
import SwiftUI

public struct TagGrid: View {
    // MARK: - Properties

    private var tags: [Tag]
    private var selectedIds: Set<Tag.ID>

    @State private var availableWidth: CGFloat = 0
    @State private var cellSizes: [Tag: CGSize] = [:]
    @State private var renamingTag: Tag? = nil
    @State private var deletingTag: Tag? = nil

    @Namespace var animation
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    private let configuration: Configuration
    private let vspacing: CGFloat
    private let hspacing: CGFloat
    private let inset: CGFloat
    private let onPerform: ((Action) -> Void)?

    // MARK: - Initializers

    public init(tags: [Tag],
                selectedIds: Set<Tag.ID>,
                configuration: Configuration = .init(.default),
                vspacing: CGFloat = 10,
                hspacing: CGFloat = 8,
                inset: CGFloat = 8,
                onPerform: ((Action) -> Void)? = nil)
    {
        self.tags = tags
        self.selectedIds = selectedIds
        self.configuration = configuration
        self.vspacing = vspacing
        self.hspacing = hspacing
        self.inset = inset
        self.onPerform = onPerform
    }

    // MARK: - View

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: vspacing) {
                ForEach(calcRows(), id: \.self) { tags in
                    HStack(spacing: hspacing) {
                        ForEach(tags) {
                            cell($0)
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .background(
                Color.clear
                    .frame(height: 5)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .onChangeFrame { frame in
                        cellSizes = [:]
                        availableWidth = frame.width
                    }
            )
            .padding(.all, inset)
        }
        .onChange(of: dynamicTypeSize) { _ in
            cellSizes = [:]
        }
        .alert(
            isPresenting: .init(get: { renamingTag != nil },
                                set: { if !$0 { renamingTag = nil } }),
            text: renamingTag?.name ?? "",
            config: .init(title: NSLocalizedString("tag_grid_alert_rename_tag_title", bundle: Bundle.this, comment: ""),
                          message: NSLocalizedString("tag_grid_alert_rename_tag_message", bundle: Bundle.this, comment: ""),
                          placeholder: NSLocalizedString("tag_grid_alert_rename_tag_placeholder", bundle: Bundle.this, comment: ""),
                          validator: { text in
                              guard let tag = renamingTag else { return text?.isEmpty == false }
                              return text != tag.name && text?.isEmpty == false
                          },
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
            Text("tag_grid_alert_delete_tag_message \(tag.name)", bundle: Bundle.this),
            isPresented: .init(get: { deletingTag?.id == tag.id },
                               set: { if !$0 { deletingTag = nil } }),
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
                    Text("tag_grid_menu_copy", bundle: Bundle.this)
                } icon: {
                    Image(systemName: "doc.on.doc")
                }
            }

            Button {
                renamingTag = tag
            } label: {
                Label {
                    Text("tag_grid_menu_rename", bundle: Bundle.this)
                } icon: {
                    Image(systemName: "text.cursor")
                }
            }

            Divider()

            Button(role: .destructive) {
                deletingTag = tag
            } label: {
                Label {
                    Text("tag_grid_menu_delete", bundle: Bundle.this)
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
            Text("tag_grid_alert_delete_tag_action", bundle: Bundle.this)
        }
        Button(role: .cancel, action: {}, label: { Text("cancel", bundle: Bundle.this) })
    }

    private func calcRows() -> [[Tag]] {
        let contentWidth = availableWidth - inset * 2

        var rows: [[Tag]] = [[]]
        var currentRow = 0
        var remainingWidth = contentWidth

        for tag in tags {
            let cellSize: CGSize
            if let size = cellSizes[tag] {
                cellSize = size
            } else {
                let size = TagCell.preferredSize(name: tag.name,
                                                 count: tag.count,
                                                 size: configuration.size,
                                                 isDeletable: configuration.style == .deletable)
                let width = min(size.width, contentWidth)
                cellSize = CGSize(width: width, height: size.height)
            }

            if rows[currentRow].isEmpty {
                rows[currentRow].append(tag)

                remainingWidth -= cellSize.width
            } else if remainingWidth - (cellSize.width + hspacing) >= 0 {
                rows[currentRow].append(tag)

                remainingWidth -= (cellSize.width + hspacing)
            } else {
                currentRow += 1
                rows.append([tag])
                remainingWidth = contentWidth

                remainingWidth -= cellSize.width
            }
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
        @State private var text: String = ""
        @State private var log: String = ""
        @State private var selectedIds: Set<Tag.ID> = .init()

        // MARK: - Initializers

        init(tags: [Tag]) {
            self.tags = tags
        }

        // MARK: - View

        var body: some View {
            VStack {
                TagGrid(tags: tags,
                        selectedIds: selectedIds,
                        configuration: .init(.selectable(.multiple), isEnabledMenu: true))
                { action in
                    switch action {
                    case let .select(tagId):
                        if selectedIds.contains(tagId) {
                            selectedIds.subtract([tagId])
                        } else {
                            selectedIds = selectedIds.union([tagId])
                        }

                    case let .delete(tagId):
                        guard let index = tags.firstIndex(where: { $0.id == tagId }) else { return }
                        log = "Deleted: \(tags[index].name)"
                        withAnimation {
                            _ = tags.remove(at: index)
                        }

                    case let .copy(tagId: tagId):
                        guard let index = tags.firstIndex(where: { $0.id == tagId }) else { return }
                        log = "Copied: \(tags[index].name)"

                    case let .rename(tagId, name):
                        guard let index = self.tags.firstIndex(where: { $0.id == tagId }) else { return }
                        log = "Renamed: \(tags[index].name) to \(name)"
                        withAnimation {
                            var tag = self.tags[index]
                            tag.name = name
                            self.tags[index] = tag
                        }
                    }
                }

                HStack {
                    TextField("Tag Name", text: $text)
                        .disableAutocorrection(true)

                    Button {
                        withAnimation {
                            tags.insert(Tag(id: UUID(), name: text), at: 0)
                        }
                    } label: {
                        Text("Add Tag")
                    }
                    .disabled(text.isEmpty)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke()
                )
                .padding([.leading, .trailing, .top])

                Text(log)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke()
                    )
                    .padding()
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
