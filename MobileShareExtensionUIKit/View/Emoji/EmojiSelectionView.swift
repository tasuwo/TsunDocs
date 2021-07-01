//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Smile
import SwiftUI

struct EmojiSelectionView: View {
    private let spacing: CGFloat = 12

    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(minimum: 50), spacing: spacing),
                               count: sizeClass == .compact ? 4 : 8),
                alignment: .center,
                spacing: spacing,
                pinnedViews: []
            ) {
                ForEach(Smile.emojiList.sorted(by: <), id: \.key) { key, value in
                    VStack {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.gray, lineWidth: 2)
                            .foregroundColor(.clear)
                            .aspectRatio(1, contentMode: .fill)
                            .overlay(
                                Text(value)
                                    .font(.system(size: 50))
                                    .aspectRatio(1, contentMode: .fill)
                            )
                        Text(key)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.all, spacing)
        }
    }
}

struct EmojiSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiSelectionView()
    }
}
