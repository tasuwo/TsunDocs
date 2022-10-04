//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import struct Domain.Emoji
import SwiftUI

struct EmojiCell: View {
    let emoji: Emoji
    let backgroundColor: Color
    let isSelected: Bool

    var body: some View {
        VStack {
            backgroundColor
                .aspectRatio(1, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    GeometryReader { proxy in
                        Text(emoji.emoji)
                            .font(.system(size: proxy.size.width * 2 / 3))
                            .position(x: proxy.frame(in: .local).midX,
                                      y: proxy.frame(in: .local).midY)

                        if isSelected {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.accentColor, lineWidth: proxy.size.width / 16)
                                .shadow(radius: proxy.size.width / 16)
                            /*
                                .shadow(color: .black.opacity(1),
                                        radius: proxy.size.width / 32,
                                        x: proxy.size.width / 32,
                                        y: proxy.size.width / 32)
                             */
                        }
                    }
                )

            Text(emoji.alias)
                .font(.caption2)
                .lineLimit(1)
        }
    }
}

struct EmojiCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EmojiCell(emoji: Emoji(alias: "+1", emoji: "👍", searchableText: "+1"),
                      backgroundColor: .red,
                      isSelected: false)
                .frame(width: 180, height: 180)

            EmojiCell(emoji: Emoji(alias: "smile", emoji: "😄", searchableText: "smile"),
                      backgroundColor: .blue,
                      isSelected: true)
                .frame(width: 180, height: 180)
        }
    }
}
