//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation
import SwiftUI

public struct BrowseView<MenuContent: View>: View {
    let minSize: CGFloat = 44

    // MARK: - Properties

    private let baseUrl: URL

    @ViewBuilder
    private let menuBuilder: () -> MenuContent

    @State private var action: WebView.Action?

    @State private var title: String?
    @State private var currentUrl: URL?
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var isLoading = false
    @State private var estimatedProgress: Double = 0
    @StateObject private var scrollState = WebViewScrollState()

    @State private var isPresentShareSheet = false

    @Environment(\.openURL) var openURL
    @Environment(\.verticalSizeClass) var verticalSizeClass

    // MARK: - Initializers

    public init(baseUrl: URL,
                @ViewBuilder menu: @escaping () -> MenuContent)
    {
        self.baseUrl = baseUrl
        self.menuBuilder = menu
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                WebView(url: baseUrl,
                        action: $action,
                        title: $title,
                        currentUrl: $currentUrl,
                        canGoBack: $canGoBack,
                        canGoForward: $canGoForward,
                        isLoading: $isLoading,
                        estimatedProgress: $estimatedProgress,
                        scrollState: scrollState)

                Divider()

                if verticalSizeClass != .compact {
                    BrowseToolBar {
                        browserBackButton()
                        Spacer()
                        browserForwardButton()
                        Spacer()
                        shareButton()
                        Spacer()
                        menuButton()
                    }
                }
            }
            .navigationTitle(title ?? NSLocalizedString("browse_view_title_loading", bundle: Bundle.module, comment: "loading"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if verticalSizeClass == .compact {
                    ToolbarItem(placement: .topBarTrailing) {
                        browserBackButton()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        browserForwardButton()
                    }
                }

                if verticalSizeClass == .compact {
                    ToolbarItem(placement: .topBarTrailing) {
                        shareButton()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        menuButton()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if isLoading {
                        Button {
                            action = .stopLoading
                        } label: {
                            Image(systemName: "xmark")
                                .font(.body.weight(.bold))
                                .frame(minWidth: minSize, minHeight: minSize)
                        }
                    } else {
                        Button {
                            action = .reload
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.body.weight(.bold))
                                .frame(minWidth: minSize, minHeight: minSize)
                        }
                    }
                }
            }
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

            if isLoading {
                VStack {
                    LinearProgressView(value: estimatedProgress, total: 1.0)
                        .frame(height: 2)
                        .padding([.top], 0)

                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private func browserBackButton() -> some View {
        Button {
            action = .goBack
        } label: {
            Image(systemName: "chevron.left")
                .font(.body.weight(.bold))
                .frame(minWidth: minSize, minHeight: minSize)
        }
        .disabled(!canGoBack)
    }

    @ViewBuilder
    private func browserForwardButton() -> some View {
        Button {
            action = .goForward
        } label: {
            Image(systemName: "chevron.right")
                .font(.body.weight(.bold))
                .frame(minWidth: minSize, minHeight: minSize)
        }
        .disabled(!canGoForward)
    }

    @ViewBuilder
    private func shareButton() -> some View {
        Button {
            isPresentShareSheet = true
        } label: {
            Image(systemName: "square.and.arrow.up")
                .font(.body.weight(.bold))
                .frame(minWidth: minSize, minHeight: minSize)
        }
        .disabled(currentUrl == nil)
    }

    @ViewBuilder
    private func menuButton() -> some View {
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

            menuBuilder()
        } label: {
            Image(systemName: "ellipsis")
                .font(.body.weight(.bold))
                .frame(minWidth: minSize, minHeight: minSize)
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
                        Button {
                            // NOP
                        } label: {
                            Label {
                                Text("Edit Info")
                            } icon: {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                }
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
