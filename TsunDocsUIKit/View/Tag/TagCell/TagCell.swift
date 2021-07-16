//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public struct TagCell<Menu: View>: View {
    // MARK: - Properties

    private let tagId: UUID
    private let tagName: String
    private let status: TagCellStatus
    private let size: TagCellSize
    private let onSelect: ((UUID) -> Void)?
    private let onDelete: ((UUID) -> Void)?
    private let menu: Menu

    @ScaledMetric private var padding: CGFloat
    @State private var cornerRadius: CGFloat = 0

    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(size.font)
            .aspectRatio(contentMode: .fit)
    }

    private var bodyContainer: some View {
        HStack(spacing: 0) {
            if status.isSelected {
                checkmark
                    .foregroundColor(.white)
                    .padding([.trailing], 2)
            } else {
                // frameサイズを合わせるため、チェックマークをベースにする
                checkmark
                    .foregroundColor(.clear)
                    .overlay(
                        Text("#")
                            .font(size.font)
                            .padding(.all, 0)
                            .scaleEffect(1.2)
                    )
                    .padding([.trailing], 2)
            }

            Text(tagName)
                .foregroundColor(status.isSelected ? .white : .primary)
                .font(size.font)
        }
    }

    private var deleteButtonContainer: some View {
        Button {
            onDelete?(tagId)
        } label: {
            Image(systemName: "xmark")
                .font(size.font)
        }
        .padding([.leading, .trailing], padding)
    }

    // MARK: - Initializers

    public init(tagId: UUID,
                tagName: String,
                status: TagCellStatus,
                size: TagCellSize = .normal,
                onSelect: ((UUID) -> Void)? = nil,
                onDelete: ((UUID) -> Void)? = nil) where Menu == EmptyView
    {
        self.tagId = tagId
        self.tagName = tagName
        self.status = status
        self.size = size
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.menu = EmptyView()
        self._padding = ScaledMetric(wrappedValue: size.padding)
    }

    public init(tagId: UUID,
                tagName: String,
                status: TagCellStatus,
                size: TagCellSize = .normal,
                onSelect: ((UUID) -> Void)? = nil,
                onDelete: ((UUID) -> Void)? = nil,
                @ViewBuilder menu: () -> Menu)
    {
        self.tagId = tagId
        self.tagName = tagName
        self.status = status
        self.size = size
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.menu = menu()
        self._padding = ScaledMetric(wrappedValue: size.padding)
    }

    // MARK: - View

    public var body: some View {
        HStack(spacing: 0) {
            bodyContainer
                .padding([.leading, .trailing], padding * 3 / 2)
                .padding([.top, .bottom], padding)
                .overlay(GeometryReader { geometry in
                    if status.isDeletable {
                        Divider()
                            .background(Color("tag_background", bundle: Bundle.this))
                            .offset(x: geometry.size.width)
                            .padding([.top, .bottom], padding)
                    } else {
                        Color.clear
                    }
                })

            if status.isDeletable {
                deleteButtonContainer
            }
        }
        .background(GeometryReader { geometry in
            let baseView = status.isSelected
                ? Color.green
                : Color("tag_background", bundle: Bundle.this)
            baseView
                .clipShape(RoundedRectangle(cornerRadius: geometry.size.height / 2,
                                            style: .continuous))
        })
        .overlay(GeometryReader { geometry in
            if status.isSelected {
                Color.clear
            } else {
                RoundedRectangle(cornerRadius: geometry.size.height / 2,
                                 style: .continuous)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(Color("tag_separator", bundle: Bundle.this))
            }
        })
        .onChangeFrame {
            cornerRadius = $0.height / 2
        }
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius,
                                       style: .continuous))
        .onTapGesture {
            onSelect?(tagId)
        }
        .contextMenu {
            menu
        }
    }
}

// MARK: - Preview

struct TagCell_Previews: PreviewProvider {
    struct Container: View {
        @State var selected: UUID?
        @State var deleted: UUID?
        @State var tappedMenu: String?

        var body: some View {
            VStack(spacing: 8) {
                HStack {
                    TagCell(tagId: UUID(),
                            tagName: "タグ",
                            status: .default,
                            onSelect: { selected = $0 })
                    TagCell(tagId: UUID(),
                            tagName: "my tag",
                            status: .selected,
                            onSelect: { selected = $0 })
                    TagCell(tagId: UUID(),
                            tagName: "😁",
                            status: .deletable,
                            onSelect: { selected = $0 },
                            onDelete: { deleted = $0 })
                }

                HStack {
                    TagCell(tagId: UUID(),
                            tagName: "タグ",
                            status: .default,
                            size: .small,
                            onSelect: { selected = $0 })
                    TagCell(tagId: UUID(),
                            tagName: "my tag",
                            status: .selected,
                            size: .small,
                            onSelect: { selected = $0 })
                    TagCell(tagId: UUID(),
                            tagName: "😁",
                            status: .deletable,
                            size: .small,
                            onSelect: { selected = $0 },
                            onDelete: { deleted = $0 })
                }

                HStack {
                    TagCell(tagId: UUID(),
                            tagName: "Menu",
                            status: .default,
                            onSelect: { selected = $0 }) {
                        Button {
                            tappedMenu = "Add"
                        } label: {
                            Label("Add", systemImage: "plus")
                        }

                        Button {
                            tappedMenu = "Call"
                        } label: {
                            Label("Call", systemImage: "phone")
                        }
                        .disabled(true)

                        Button(role: .cancel) {
                            tappedMenu = "Cancel"
                        } label: {
                            Text("Cancel")
                        }

                        Divider()

                        Button(role: .destructive) {
                            tappedMenu = "Delete"
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }

                if let selected = selected {
                    Text("Selected: id=\(selected.uuidString)")
                        .foregroundColor(.gray)
                        .font(.callout)
                        .padding([.trailing, .leading])
                }

                if let deleted = deleted {
                    Text("Deleted: id=\(deleted.uuidString)")
                        .foregroundColor(.gray)
                        .font(.callout)
                        .padding([.trailing, .leading])
                }

                if let tappedMenu = tappedMenu {
                    Text("Tapped menu: name=\(tappedMenu)")
                        .foregroundColor(.gray)
                        .font(.callout)
                        .padding([.trailing, .leading])
                }
            }
        }
    }

    static var previews: some View {
        Group {
            Container()
                .preferredColorScheme(.light)

            Container()
                .preferredColorScheme(.light)
                .environment(\.sizeCategory, .extraSmall)

            Container()
                .preferredColorScheme(.light)
                .environment(\.sizeCategory, .extraLarge)

            Container()
                .preferredColorScheme(.dark)
        }
    }
}
