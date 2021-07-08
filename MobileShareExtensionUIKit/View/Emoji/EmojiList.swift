//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import Smile
import SwiftUI
import TsunDocsUIKit

public struct EmojiList: View {
    // MARK: - Properties

    private static let spacing: CGFloat = 16
    private static let allEmojis = Smile.emojiList
        .sorted(by: <)
        .map {
            Emoji(alias: $0.key,
                  emoji: $0.value,
                  searchableText: $0.key.transformToSearchableText()!)
        }

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var engine: TextEngine = .init(debounceFor: 0.3)

    @State var storage: SearchableStorage<Emoji> = .init()
    @State var emojis: [Emoji] = Self.allEmojis

    @Binding var selectedEmoji: Emoji?

    private let searchQueue = DispatchQueue(label: "net.tasuwo.MobileShareExtensionUIKit.EmojiList.search")

    // MARK: - View

    public var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(minimum: 50), spacing: Self.spacing),
                               count: sizeClass == .compact ? 4 : 8),
                alignment: .center,
                spacing: Self.spacing,
                pinnedViews: []
            ) {
                ForEach(emojis) { emoji in
                    EmojiCell(emoji: emoji)
                        .onTapGesture {
                            selectedEmoji = emoji
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
            .padding(.all, Self.spacing)
        }
        .searchable(text: $engine.input)
        .navigationTitle(Text("emoji_list_title", bundle: Bundle.this))
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
    struct Container: View {
        @State var selectedEmoji: Emoji?
        @State var isPresenting: Bool = false

        var selectedEmojiText: String {
            guard let emoji = selectedEmoji else {
                return "No emojis selected."
            }
            return emoji.emoji + emoji.alias
        }

        var body: some View {
            VStack {
                Text(selectedEmojiText)
                    .sheet(isPresented: $isPresenting) {
                        NavigationView {
                            EmojiList(selectedEmoji: $selectedEmoji)
                        }
                    }
                    .padding()

                Button {
                    isPresenting = true
                } label: {
                    Text("Select emoji")
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}