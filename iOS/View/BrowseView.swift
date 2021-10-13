//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

struct BrowseView: View {
    // MARK: - Properties

    private let baseUrl: URL
    private let onEdit: () -> Void
    private let onClose: (() -> Void)?

    @State private var action: WebView.Action?

    @State private var title: String?
    @State private var currentUrl: URL?
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var isLoading = false
    @State private var estimatedProgress: Double = 0

    @State private var isPresentShareSheet = false

    @Environment(\.openURL) var openURL

    // MARK: - Initializers

    init(baseUrl: URL,
         onEdit: @escaping () -> Void,
         onClose: (() -> Void)? = nil)
    {
        self.baseUrl = baseUrl
        self.onEdit = onEdit
        self.onClose = onClose
    }

    // MARK: - View

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                WebView(url: baseUrl,
                        action: $action,
                        title: $title,
                        currentUrl: $currentUrl,
                        canGoBack: $canGoBack,
                        canGoForward: $canGoForward,
                        isLoading: $isLoading,
                        estimatedProgress: $estimatedProgress)

                if isLoading {
                    VStack(spacing: 0) {
                        ProgressView(value: estimatedProgress, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                        Spacer()
                    }
                }
            }
        }
        .navigationBarTitle(title ?? NSLocalizedString("browse_view_title_loading", comment: "loading"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isPresentShareSheet) {
            let url: URL = {
                if let currentUrl = currentUrl {
                    return currentUrl
                } else {
                    return baseUrl
                }
            }()
            ShareSheet(activityItems: [url])
                .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let onClose = onClose {
                    Button {
                        onClose()
                    } label: {
                        Text("browse_view_button_close")
                    }
                } else {
                    EmptyView()
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if isLoading {
                    Button {
                        action = .stopLoading
                    } label: {
                        Image(systemName: "xmark")
                    }
                } else {
                    Button {
                        action = .reload
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }

            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    action = .goBack
                } label: {
                    Image(systemName: "chevron.left")
                }
                .disabled(!canGoBack)

                Spacer()

                Button {
                    action = .goForward
                } label: {
                    Image(systemName: "chevron.right")
                }
                .disabled(!canGoForward)

                Spacer()

                Button {
                    isPresentShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(currentUrl == nil)

                Spacer()

                Menu {
                    Button {
                        guard let url = currentUrl else { return }
                        openURL(url)
                    } label: {
                        Label {
                            Text(L10n.browseViewButtonSafari)
                        } icon: {
                            Image(systemName: "safari")
                        }
                    }
                    .disabled(currentUrl == nil)

                    Button {
                        onEdit()
                    } label: {
                        Label {
                            Text(L10n.browseViewButtonEdit)
                        } icon: {
                            Image(systemName: "pencil")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding([.top, .bottom])
                }
            }
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    struct Container: View {
        @State var isPresenting = false

        var body: some View {
            Button {
                isPresenting = true
            } label: {
                Text("Press me")
            }
            .sheet(isPresented: $isPresenting) {
                NavigationView {
                    // swiftlint:disable:next force_unwrapping
                    BrowseView(baseUrl: URL(string: "https://www.apple.com")!) {
                        // NOP
                    } onClose: {
                        isPresenting = false
                    }
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
