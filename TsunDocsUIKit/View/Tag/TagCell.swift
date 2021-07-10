//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public struct TagCell: View {
    // MARK: - Properties

    public let tagId: UUID
    public let tagName: String
    public let isSelected: Bool
    public let size: TagCellSize

    @ScaledMetric private var padding: CGFloat

    var checkmark: some View {
        Image(systemName: "checkmark")
            .font(size.font)
            .aspectRatio(contentMode: .fit)
    }

    // MARK: - Initializers

    public init(tagId: UUID,
                tagName: String,
                isSelected: Bool = false,
                size: TagCellSize = .normal)
    {
        self.tagId = tagId
        self.tagName = tagName
        self.isSelected = isSelected
        self.size = size
        self._padding = ScaledMetric(wrappedValue: size.padding)
    }

    // MARK: - View

    public var body: some View {
        HStack(spacing: 0) {
            if isSelected {
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
                .foregroundColor(isSelected ? .white : .primary)
                .font(size.font)
        }
        .padding([.leading, .trailing], padding * 2)
        .padding([.top, .bottom], padding)
        .background(GeometryReader { geometry in
            let baseView = isSelected
                ? Color.green
                : Color("tag_background", bundle: Bundle.this)
            baseView
                .clipShape(RoundedRectangle(cornerRadius: geometry.size.height / 2,
                                            style: .continuous))
        })
        .overlay(GeometryReader { geometry in
            if isSelected {
                Color.clear
            } else {
                RoundedRectangle(cornerRadius: geometry.size.height / 2,
                                 style: .continuous)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(Color("tag_separator", bundle: Bundle.this))
            }
        })
    }
}

// MARK: - Preview

struct TagCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                HStack {
                    TagCell(tagId: UUID(), tagName: "タグ", isSelected: false)
                    TagCell(tagId: UUID(), tagName: "my tag", isSelected: true)
                }
                HStack {
                    TagCell(tagId: UUID(), tagName: "タグ", isSelected: false, size: .small)
                    TagCell(tagId: UUID(), tagName: "my tag", isSelected: true, size: .small)
                }
            }
            .preferredColorScheme(.light)

            VStack {
                HStack {
                    TagCell(tagId: UUID(), tagName: "タグ", isSelected: false)
                    TagCell(tagId: UUID(), tagName: "my tag", isSelected: true)
                }
                HStack {
                    TagCell(tagId: UUID(), tagName: "タグ", isSelected: false, size: .small)
                    TagCell(tagId: UUID(), tagName: "my tag", isSelected: true, size: .small)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
