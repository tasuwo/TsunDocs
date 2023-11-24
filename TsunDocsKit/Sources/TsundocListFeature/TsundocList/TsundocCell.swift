//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import Smile
import SwiftUI

struct TsundocCell<MenuContent>: View where MenuContent: View {
    // MARK: - Properties

    let tsundoc: Tsundoc
    @ViewBuilder
    let menuContent: () -> MenuContent

    // MARK: - View

    var body: some View {
        HStack(spacing: 4) {
            VStack {
                TsundocThumbnail(source: tsundoc.thumbnailSource)
                    .padding([.top, .trailing, .bottom], 4.0)
                Spacer(minLength: 0)
            }

            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text(tsundoc.title)
                                .font(.headline)
                                .lineLimit(3)
                                .foregroundColor(.primary)
                                .padding(.top, 4.0)

                            Spacer()
                                .frame(height: 8.0)

                            if let description = tsundoc.description {
                                Text(description)
                                    .font(.caption)
                                    .lineLimit(3)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(.top, 4)

                    Spacer()

                    VStack {
                        if tsundoc.isUnread {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 8, height: 8)
                                .padding([.top], 8.0)
                        } else {
                            Circle()
                                .fill(.clear)
                                .frame(width: 8, height: 8)
                                .padding([.top], 8.0)
                        }
                        Spacer()
                    }
                }

                HStack {
                    Spacer()

                    Menu {
                        menuContent()
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                            .frame(minWidth: 32, minHeight: 32)
                    }
                    // HACK: Cellのタップ判定を握りつぶす
                    .onTapGesture {}
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
    }
}

// MARK: - Preview

#if DEBUG
import PreviewContent

struct TsundocCell_Previews: PreviewProvider {
    static let longString = """
    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    """

    static var previews: some View {
        Group {
            NavigationView {
                List {
                    TsundocCell(tsundoc: .makeDefault(title: "Title only",
                                                      isUnread: true)) { EmptyView() }

                    TsundocCell(tsundoc: .makeDefault(title: "Title with description",
                                                      description: "This is description of website.")) { EmptyView() }

                    TsundocCell(tsundoc: .makeDefault(title: "Emoji thumbnail", emojiAlias: "smile")) { EmptyView() }

                    TsundocCell(tsundoc: .makeDefault(title: "Success image thumbnail",
                                                      imageUrl: URL(string: "http://localhost"))) { EmptyView() }

                    TsundocCell(tsundoc: .makeDefault(title: "Failure image thumbnail",
                                                      imageUrl: URL(string: "http://localhost"))) { EmptyView() }

                    TsundocCell(tsundoc: .makeDefault(title: longString,
                                                      description: longString,
                                                      emojiAlias: "ghost",
                                                      isUnread: true)) { EmptyView() }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("TsundocCell")
            }
            .preferredColorScheme(.light)
        }
    }
}

#endif
