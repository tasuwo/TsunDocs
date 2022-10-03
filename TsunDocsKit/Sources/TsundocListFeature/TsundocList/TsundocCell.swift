//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import ImageLoader
import Smile
import SwiftUI

struct TsundocCell: View {
    // MARK: - Properties

    @Environment(\.imageLoaderFactory) var imageLoaderFactory

    let tsundoc: Tsundoc

    // MARK: - View

    var body: some View {
        HStack {
            VStack {
                TsundocThumbnail(source: tsundoc.thumbnailSource)
                    .padding([.top, .trailing, .bottom], 4.0)
                Spacer(minLength: 0)
            }

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
                            .font(.subheadline)
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
                                                      isUnread: true))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: "Title with description",
                                                      description: "This is description of website."))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: "Emoji thumbnail", emojiAlias: "smile"))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: "Success image thumbnail",
                                                      imageUrl: URL(string: "http://localhost")))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: "Failure image thumbnail",
                                                      imageUrl: URL(string: "http://localhost")))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(FailureMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: longString,
                                                      description: longString,
                                                      emojiAlias: "ghost",
                                                      isUnread: true))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("TsundocCell")
            }
            .preferredColorScheme(.light)

            NavigationView {
                List {
                    TsundocCell(tsundoc: .makeDefault(title: "Title only",
                                                      isUnread: true))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: "Title with description",
                                                      description: "This is description of website."))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: "Emoji thumbnail", emojiAlias: "smile"))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: "Success image thumbnail",
                                                      imageUrl: URL(string: "http://localhost")))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: "Failure image thumbnail",
                                                      imageUrl: URL(string: "http://localhost")))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(FailureMock.self)) })

                    TsundocCell(tsundoc: .makeDefault(title: longString,
                                                      description: longString,
                                                      emojiAlias: "ghost",
                                                      isUnread: true))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(FailureMock.self)) })
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("TsundocCell")
            }
            .preferredColorScheme(.dark)
        }
    }
}

#endif
