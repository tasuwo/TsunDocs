//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import struct Domain.Emoji
import SearchKit
import SwiftUI

public struct EmojiList<BackgroundColor>: View where BackgroundColor: PickColor, BackgroundColor.RawValue: Hashable {
    public typealias FilterStore = ViewStore<
        SearchableFilterState<Emoji>,
        SearchableFilterAction<Emoji>,
        SearchableFilterDepenency
    >

    // MARK: - Properties

    private let spacing: CGFloat = 16
    private let allEmojis = Emoji.emojiList()

    let backgroundColors: BackgroundColor.Type

    @State var emojis: [Emoji]
    @State var backgroundColorRawValue: BackgroundColor.RawValue = BackgroundColor.default.rawValue

    @StateObject private var filterStore: FilterStore
    @StateObject var engine: TextEngine = .init(debounceFor: 0.3)

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.presentationMode) var presentationMode

    private let onSelected: (Emoji, BackgroundColor) -> Void

    // MARK: - Initializers

    public init(backgroundColors: BackgroundColor.Type, onSelected: @escaping (Emoji, BackgroundColor) -> Void) {
        self.backgroundColors = backgroundColors
        self.onSelected = onSelected

        let emojis = allEmojis
        _emojis = State(wrappedValue: emojis)
        let store = Store(initialState: .init(items: emojis),
                          dependency: (),
                          reducer: SearchableFilterReducer<Emoji>())
        _filterStore = StateObject(wrappedValue: ViewStore(store: store))
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(minimum: 50), spacing: spacing),
                                       count: sizeClass == .compact ? 4 : 8),
                        alignment: .center,
                        spacing: spacing,
                        pinnedViews: []
                    ) {
                        ForEach(filterStore.state.filteredItems) { emoji in
                            EmojiCell(emoji: emoji, backgroundColor: backgroundColors.init(rawValue: backgroundColorRawValue)!.swiftUIColor)
                                .onTapGesture {
                                    onSelected(emoji, backgroundColors.init(rawValue: backgroundColorRawValue)!)
                                }
                        }
                    }
                    .padding(.all, spacing)
                }

                colorPicker()
                    .hidden()
            }
            .searchable(text: $engine.input, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle(Text("emoji_list_title", bundle: Bundle.this))
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: engine.output) { query in
                filterStore.execute(.updateQuery(query), animation: .default)
            }
            .onChange(of: emojis) { emojis in
                filterStore.execute(.updateItems(emojis), animation: .default)
            }

            VStack {
                Spacer()
                colorPicker()
            }
        }
    }

    @ViewBuilder
    private func colorPicker() -> some View {
        ColorPicker(color: backgroundColors.self,
                    selected: $backgroundColorRawValue) {
            backgroundColorRawValue = $0
        }
        .frame(maxWidth: 320)
        .padding(16)
    }
}

struct EmojiList_Previews: PreviewProvider {
    struct Container: View {
        @State var selectedEmoji: Emoji?
        @State var selectedBackgroundColor: DefaultPickColor?
        @State var isPresenting = false

        var selectedEmojiText: String {
            guard let emoji = selectedEmoji else {
                return "No emojis selected."
            }
            return emoji.emoji + emoji.alias
        }

        var selectedBackgroundColorText: String {
            guard let color = selectedBackgroundColor else {
                return "No backgroundColor selected."
            }
            return color.rawValue
        }

        var body: some View {
            VStack {
                Text(selectedEmojiText)
                    .padding(.bottom)

                if let color = selectedBackgroundColor {
                    HStack {
                        Text("backgroundColor: ")
                        Circle()
                            .fill(color.swiftUIColor)
                            .frame(width: 22, height: 22)
                            .overlay {
                                Circle()
                                    .strokeBorder()
                            }
                    }
                    .padding(.bottom)
                }

                Button {
                    isPresenting = true
                } label: {
                    Text("Select emoji")
                }
            }
            .sheet(isPresented: $isPresenting) {
                NavigationView {
                    EmojiList(backgroundColors: DefaultPickColor.self) {
                        selectedEmoji = $0
                        selectedBackgroundColor = $1
                        withAnimation { isPresenting = false }
                    }
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
