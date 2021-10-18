//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Emoji
import SwiftUI

struct EmojiCell: View {
    let emoji: Emoji

    var body: some View {
        VStack {
            Color("emoji_background", bundle: Bundle.this)
                .aspectRatio(1, contentMode: .fill)
                .overlay(
                    GeometryReader { proxy in
                        Text(emoji.emoji)
                            .font(.system(size: proxy.size.width * 2 / 3))
                            .position(x: proxy.frame(in: .local).midX,
                                      y: proxy.frame(in: .local).midY)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

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
