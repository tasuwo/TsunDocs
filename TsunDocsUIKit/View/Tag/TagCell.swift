//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public struct TagCell: View {
    // MARK: - Properties

    public let tagId: UUID
    public let tagName: String

    @State var isSelected = false

    // MARK: - View

    public var body: some View {
        HStack(spacing: 0) {
            if isSelected {
                Image(systemName: "checkmark")
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing, 2)
                    .frame(width: 18, height: 18)
                    .fixedSize()
                    .foregroundColor(.white)
            } else {
                Text("#")
                    .font(.system(size: 20))
                    .padding(.all, 0)
                    .frame(width: 18, height: 18)
                    .fixedSize()
            }

            Text(tagName)
                .foregroundColor(isSelected ? .white : .primary)
                .font(.system(size: 16))
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
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
                TagCell(tagId: UUID(), tagName: "タグ", isSelected: false)
                TagCell(tagId: UUID(), tagName: "my tag", isSelected: true)
            }
            .preferredColorScheme(.light)

            VStack {
                TagCell(tagId: UUID(), tagName: "タグ", isSelected: false)
                TagCell(tagId: UUID(), tagName: "my tag", isSelected: true)
            }
            .preferredColorScheme(.dark)
        }
    }
}
