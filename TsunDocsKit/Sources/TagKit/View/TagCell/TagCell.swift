//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Tag
import SwiftUI

public struct TagCell: View {
    // MARK: - Properties

    private let id: Tag.ID
    private let name: String
    private let count: Int
    private let status: Status
    private let size: Size

    private let onPerform: ((Action) -> Void)?

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

            HStack(spacing: 4) {
                Text(name)
                    .foregroundColor(status.isSelected ? .white : .primary)
                    .font(size.font)
                    .lineLimit(1)

                Text("(\(count))")
                    .foregroundColor(status.isSelected ? .white : .secondary)
                    .font(size.font)
                    .lineLimit(1)
            }
        }
    }

    private var deleteButtonContainer: some View {
        Button {
            onPerform?(.delete(id))
        } label: {
            Image(systemName: "xmark")
                .font(size.font)
        }
        .padding([.leading, .trailing], padding)
    }

    // MARK: - Initializers

    public init(id: UUID,
                name: String,
                count: Int,
                status: Status,
                size: Size = .normal,
                onPerform: ((Action) -> Void)? = nil)
    {
        self.id = id
        self.name = name
        self.count = count
        self.status = status
        self.size = size
        self.onPerform = onPerform
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
            onPerform?(.select(id))
        }
    }

    // MARK: - Methods

    static func preferredSize(name: String, count: Int, size: TagCell.Size, isDeletable: Bool) -> CGSize {
        let font = size.font
        let padding = size.padding.scaledValueWithDefaultMetrics()

        let markSize = String.labelSizeOfSymbol(systemName: "checkmark", withFont: font)
        let tagNameSize = name.labelSize(withFont: font)
        let countLabelSize = "(\(count))".labelSize(withFont: font)

        let cellHeight = max(markSize.height, tagNameSize.height, countLabelSize.height) + padding * 2

        let bodyWidth = markSize.width + 2 + tagNameSize.width + 4 + countLabelSize.width
        let horizontalPadding = padding * 3 / 2
        var cellWidth = bodyWidth + horizontalPadding * 2

        if isDeletable {
            cellWidth += padding * 2 + String.labelSizeOfSymbol(systemName: "xmark", withFont: font).width
        }

        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - Preview

struct TagCell_Previews: PreviewProvider {
    struct Container: View {
        @State var selected: UUID?
        @State var deleted: UUID?

        var body: some View {
            VStack(spacing: 8) {
                HStack {
                    TagCell(id: UUID(),
                            name: "タグ",
                            count: 5,
                            status: .default) {
                        switch $0 {
                        case let .select(tagId):
                            selected = tagId

                        default: ()
                        }
                    }
                    TagCell(id: UUID(),
                            name: "my tag",
                            count: 5,
                            status: .selected) {
                        switch $0 {
                        case let .select(tagId):
                            selected = tagId

                        default: ()
                        }
                    }
                    TagCell(id: UUID(),
                            name: "😁",
                            count: 5,
                            status: .deletable) {
                        switch $0 {
                        case let .select(tagId):
                            selected = tagId

                        case let .delete(tagId):
                            deleted = tagId
                        }
                    }
                }

                HStack {
                    TagCell(id: UUID(),
                            name: "タグ",
                            count: 5,
                            status: .default,
                            size: .small) {
                        switch $0 {
                        case let .select(tagId):
                            selected = tagId

                        default: ()
                        }
                    }
                    TagCell(id: UUID(),
                            name: "my tag",
                            count: 5,
                            status: .selected,
                            size: .small) {
                        switch $0 {
                        case let .select(tagId):
                            selected = tagId

                        default: ()
                        }
                    }
                    TagCell(id: UUID(),
                            name: "😁",
                            count: 5,
                            status: .deletable,
                            size: .small) {
                        switch $0 {
                        case let .select(tagId):
                            selected = tagId

                        case let .delete(tagId):
                            deleted = tagId
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
