//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Smile
import SwiftUI

struct TsundocCell: View {
    // MARK: - Properties

    private let tsundoc: Tsundoc
    private let imageLoaderFactory: Factory<ImageLoader>

    // MARK: - Initializers

    init(tsundoc: Tsundoc,
         imageLoaderFactory: Factory<ImageLoader> = .default)
    {
        self.tsundoc = tsundoc
        self.imageLoaderFactory = imageLoaderFactory
    }

    // MARK: - View

    var body: some View {
        HStack {
            VStack {
                TsundocThumbnail(source: tsundoc.thumbnailSource,
                                 imageLoaderFactory: imageLoaderFactory)
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
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, UIImage(named: "320x320")!.pngData()) }
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

    static func makeTsundoc(title: String,
                            description: String? = nil,
                            imageUrl: URL? = nil,
                            emojiAlias: String? = nil) -> Tsundoc
    {
        return .init(id: UUID(),
                     title: title,
                     description: description,
                     // swiftlint:disable:next force_unwrapping
                     url: URL(string: "https://localhost")!,
                     imageUrl: imageUrl,
                     emojiAlias: emojiAlias,
                     updatedDate: Date(),
                     createdDate: Date())
    }

    static var previews: some View {
        Group {
            NavigationView {
                List {
                    TsundocCell(tsundoc: makeTsundoc(title: "Title only"),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: "Title with description",
                                                     description: "This is description of website."),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: "Emoji thumbnail",
                                                     emojiAlias: "smile"),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: "Success image thumbnail",
                                                     imageUrl: URL(string: "http://localhost")),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: "Failure image thumbnail",
                                                     imageUrl: URL(string: "http://localhost")),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(FailureMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: longString,
                                                     description: longString,
                                                     emojiAlias: "ghost"),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })
                }
                .navigationTitle("TsundocCell")
            }
            .preferredColorScheme(.light)

            NavigationView {
                List {
                    TsundocCell(tsundoc: makeTsundoc(title: "Title only"),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: "Title with description",
                                                     description: "This is description of website."),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: "Emoji thumbnail",
                                                     emojiAlias: "smile"),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: "Success image thumbnail",
                                                     imageUrl: URL(string: "http://localhost")),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: "Failure image thumbnail",
                                                     imageUrl: URL(string: "http://localhost")),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(FailureMock.self)) })

                    TsundocCell(tsundoc: makeTsundoc(title: longString,
                                                     description: longString,
                                                     emojiAlias: "ghost"),
                                imageLoaderFactory: .init { .init(urlSession: .makeMock(SuccessMock.self)) })
                }
                .navigationTitle("TsundocCell")
            }
            .preferredColorScheme(.dark)
        }
    }
}
