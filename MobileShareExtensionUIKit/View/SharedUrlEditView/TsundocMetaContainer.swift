//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TsunDocsUIKit

public struct TsundocMetaContainer: View {
    // MARK: - Properties

    private let url: URL
    private let title: String
    private let onTapEditTitleButton: () -> Void

    @Environment(\.tsundocEditThumbnailStoreBuilder) var tsundocEditThumbnailStoreBuilder

    // MARK: - Initializers

    public init(url: URL,
                title: String,
                onTapEditTitleButton: @escaping () -> Void)
    {
        self.url = url
        self.title = title
        self.onTapEditTitleButton = onTapEditTitleButton
    }

    // MARK: - View

    public var body: some View {
        HStack(alignment: .top) {
            VStack {
                let store = tsundocEditThumbnailStoreBuilder.buildTsundocEditThumbnailStore()
                TsundocEditThumbnail(store: store)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if !title.isEmpty {
                        Text(title)
                            .lineLimit(4)
                            .font(.body)
                    } else {
                        Text("shared_url_edit_view_no_title", bundle: Bundle.this)
                            .foregroundColor(.gray)
                            .font(.title3)
                    }

                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.cyan)
                        .font(.system(size: 24))
                }
                .onTapGesture {
                    onTapEditTitleButton()
                }

                Text(url.absoluteString)
                    .lineLimit(2)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding([.top, .bottom], TsundocEditThumbnail.padding)

            Spacer()
        }
    }
}

// MARK: - Preview

@MainActor
struct TsundocMetaContainer_Previews: PreviewProvider {
    class Dependency: TsundocEditThumbnailDependency {}

    class SuccessMock: URLProtocolMockBase {
        override class var mock_delay: TimeInterval? { 3 }
        override class var mock_handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
            // swiftlint:disable:next force_unwrapping
            return { _ in (.mock_success, UIImage(named: "320x320", in: Bundle.this, with: nil)!.pngData()) }
        }
    }

    class StoreBuilder: TsundocEditThumbnailStoreBuildable {
        typealias Store = ViewStore<TsundocEditThumbnailState, TsundocEditThumbnailAction, TsundocEditThumbnailDependency>

        let store: Store

        init(_ store: Store) {
            self.store = store
        }

        func buildTsundocEditThumbnailStore() -> Store {
            return store
        }
    }

    static var previews: some View {
        let imageLoaderFactory = Factory<ImageLoader> {
            .init(urlSession: .makeMock(SuccessMock.self))
        }

        VStack {
            Divider()

            // swiftlint:disable:next force_unwrapping
            TsundocMetaContainer(url: URL(string: "https://apple.com")!,
                                 title: "My Title",
                                 onTapEditTitleButton: {})
                .environment(\.imageLoaderFactory, imageLoaderFactory)
                .environment(\.tsundocEditThumbnailStoreBuilder,
                             // swiftlint:disable:next force_unwrapping
                             StoreBuilder(makeStore(imageUrl: URL(string: "https://localhost")!)))

            Divider()

            // swiftlint:disable:next force_unwrapping
            TsundocMetaContainer(url: URL(string: "https://apple.com")!,
                                 title: "",
                                 onTapEditTitleButton: {})
                .environment(\.imageLoaderFactory, imageLoaderFactory)
                .environment(\.tsundocEditThumbnailStoreBuilder,
                             StoreBuilder(makeStore(imageUrl: nil)))

            Divider()

            // swiftlint:disable:next force_unwrapping
            TsundocMetaContainer(url: URL(string: "https://apple.com")!,
                                 title: String(repeating: "Title ", count: 100),
                                 onTapEditTitleButton: {})
                .environment(\.imageLoaderFactory, imageLoaderFactory)
                .environment(\.tsundocEditThumbnailStoreBuilder,
                             // swiftlint:disable:next force_unwrapping
                             StoreBuilder(makeStore(imageUrl: URL(string: "https://localhost/\(String(repeating: "long/", count: 100))")!)))

            Divider()
        }
    }

    static func makeStore(imageUrl: URL?) -> ViewStore<TsundocEditThumbnailState, TsundocEditThumbnailAction, TsundocEditThumbnailDependency> {
        let store = Store(initialState: TsundocEditThumbnailState(imageUrl: imageUrl,
                                                                  thumbnailLoadingStatus: nil,
                                                                  selectedEmoji: nil,
                                                                  isSelectingEmoji: false),
                          dependency: Dependency(),
                          reducer: TsundocEditThumbnailReducer())
        return ViewStore(store: store)
    }
}
