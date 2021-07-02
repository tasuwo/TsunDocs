//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import Smile
import SwiftUI
import TsunDocsUIKit

struct EmojiList: View {
    private static let spacing: CGFloat = 16
    private static let allEmojis = Smile.emojiList
        .sorted(by: <)
        .map {
            Emoji(alias: $0.key,
                  emoji: $0.value,
                  searchableText: $0.key.transformToSearchableText()!)
        }

    @Environment(\.horizontalSizeClass) var sizeClass

    @ObservedObject var engine: TextEngine = .init(debounceFor: 0.3)

    @State var storage: SearchableStorage<Emoji> = .init()
    @State var emojis: [Emoji] = Self.allEmojis

    private let searchQueue = DispatchQueue(label: "net.tasuwo.MobileShareExtensionUIKit.EmojiList.search")

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(minimum: 50), spacing: Self.spacing),
                               count: sizeClass == .compact ? 4 : 8),
                alignment: .center,
                spacing: Self.spacing,
                pinnedViews: []
            ) {
                ForEach(emojis) {
                    EmojiCell(emoji: $0)
                }
            }
            .padding(.all, Self.spacing)
            .searchable(text: $engine.input)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: engine.output) { query in
            searchQueue.async {
                withAnimation {
                    self.emojis = self.storage.perform(query: query, to: Self.allEmojis)
                }
            }
        }
    }
}

struct EmojiList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmojiList()
        }
    }
}
