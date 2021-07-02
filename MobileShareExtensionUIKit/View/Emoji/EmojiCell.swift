//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

struct EmojiCell: View {
    let emoji: Emoji

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.gray, lineWidth: 0.5)
                .foregroundColor(.clear)
                .aspectRatio(1, contentMode: .fill)
                .overlay(
                    Text(emoji.emoji)
                        .font(.system(size: 45))
                        .aspectRatio(1, contentMode: .fill)
                )

            Text(emoji.alias)
                .font(.caption2)
                .lineLimit(1)
        }
    }
}

struct EmojiCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                EmojiCell(emoji: Emoji(alias: "+1", emoji: "👍", searchableText: "+1"))
                EmojiCell(emoji: Emoji(alias: "smile", emoji: "😄", searchableText: "smile"))
            }
        }
    }
}
