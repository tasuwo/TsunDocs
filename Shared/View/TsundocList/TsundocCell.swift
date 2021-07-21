//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
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
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .padding(.top, 4.0)

                    Spacer()
                        .frame(height: 4.0)

                    if let description = tsundoc.description {
                        Text(description)
                            .font(.caption)
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer(minLength: 0)
            }

            Spacer()
        }
    }
}

// MARK: - Preview

struct TsundocCell_Previews: PreviewProvider {
    class SuccessMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            #if os(iOS)
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, UIImage(named: "320x320")!.pngData()) }
            #elseif os(macOS)
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, NSImage(named: "320x320")!.tiffRepresentation) }
            #endif
        }
    }

    class FailureMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            return { _ in (.mock_failure, nil) }
        }
    }

    static let longString = """
    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    """

    static var previews: some View {
        Group {
            NavigationView {
                List {
                    TsundocCell(tsundoc: .makeDefault(title: "Title only"))
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
                                                      emojiAlias: "ghost"))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(SuccessMock.self)) })
                }
                .navigationTitle("TsundocCell")
            }
            .preferredColorScheme(.light)

            NavigationView {
                List {
                    TsundocCell(tsundoc: .makeDefault(title: "Title only"))
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
                                                      emojiAlias: "ghost"))
                        .environment(\.imageLoaderFactory, .init { .init(urlSession: .makeMock(FailureMock.self)) })
                }
                .navigationTitle("TsundocCell")
            }
            .preferredColorScheme(.dark)
        }
    }
}
