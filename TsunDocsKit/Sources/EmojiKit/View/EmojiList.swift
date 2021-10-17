//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import SearchKit
import SwiftUI

public struct EmojiList: View {
    public typealias FilterStore = ViewStore<
        SearchableFilterState<Emoji>,
        SearchableFilterAction<Emoji>,
        SearchableFilterDepenency
    >

    // MARK: - Properties

    private static let spacing: CGFloat = 16
    private static let allEmojis = Emoji.emojiList()

    @State var emojis: [Emoji]

    @StateObject private var filterStore: FilterStore
    @StateObject var engine: TextEngine = .init(debounceFor: 0.3)

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.presentationMode) var presentationMode

    private let onSelected: (Emoji) -> Void

    // MARK: - Initializers

    public init(onSelected: @escaping (Emoji) -> Void) {
        self.onSelected = onSelected

        let emojis = Self.allEmojis
        _emojis = State(wrappedValue: emojis)
        let store = Store(initialState: .init(items: emojis),
                          dependency: Nop(),
                          reducer: SearchableFilterReducer<Emoji>())
        _filterStore = StateObject(wrappedValue: ViewStore(store: store))
    }

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
                ForEach(filterStore.state.filteredItems) { emoji in
                    EmojiCell(emoji: emoji)
                        .onTapGesture {
                            onSelected(emoji)
                        }
                }
            }
            .padding(.all, Self.spacing)
        }
        .searchable(text: $engine.input, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle(Text("emoji_list_title", bundle: Bundle.module))
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: engine.output) { query in
            filterStore.execute(.updateQuery(query), animation: .default)
        }
        .onChange(of: emojis) { emojis in
            filterStore.execute(.updateItems(emojis), animation: .default)
        }
    }
}

struct EmojiList_Previews: PreviewProvider {
    struct Container: View {
        @State var selectedEmoji: Emoji?
        @State var isPresenting = false

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
                            EmojiList {
                                selectedEmoji = $0
                                withAnimation { isPresenting = false }
                            }
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
