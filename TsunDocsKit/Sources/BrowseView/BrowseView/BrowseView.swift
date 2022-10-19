//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation
import SwiftUI

public struct BrowseView<MenuContent: View>: View {
    let minSize: CGFloat = 44

    // MARK: - Properties

    private let baseUrl: URL
    private let onBack: (() -> Void)?
    private let onClose: (() -> Void)?

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
                @ViewBuilder menu: @escaping () -> MenuContent,
                onBack: (() -> Void)? = nil,
                onClose: (() -> Void)? = nil)
    {
        self.baseUrl = baseUrl
        self.menuBuilder = menu
        self.onBack = onBack
        self.onClose = onClose
    }

    // MARK: - View

    public var body: some View {
        VStack(spacing: 0) {
            if !scrollState.isNavigationBarHidden {
                BrowseNavigationBar(title: title ?? NSLocalizedString("browse_view_title_loading", bundle: Bundle.module, comment: "loading")) {
                    if let onBack = onBack {
                        Button {
                            onBack()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .font(.body.weight(.bold))
                                .frame(minWidth: minSize, minHeight: minSize)
                        }
                    }

                    if let onClose = onClose {
                        Button {
                            onClose()
                        } label: {
                            Text("browse_view_button_close", bundle: Bundle.module)
                                .font(.body.weight(.bold))
                                .frame(minWidth: minSize, minHeight: minSize)
                        }
                    }

                    if verticalSizeClass == .compact {
                        browserBackButton()
                        browserForwardButton()
                    }

                    EmptyView()
                } trailing: {
                    if verticalSizeClass == .compact {
                        shareButton()
                        menuButton()
                    }

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

            if isLoading {
                ProgressView(value: estimatedProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
            }

            Divider()

            WebView(url: baseUrl,
                    action: $action,
                    title: $title,
                    currentUrl: $currentUrl,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    isLoading: $isLoading,
                    estimatedProgress: $estimatedProgress,
                    scrollState: scrollState)
                .edgesIgnoringSafeArea([.leading, .trailing])

            Divider()

            if verticalSizeClass != .compact, !scrollState.isToolbarHidden {
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
        .navigationBarHidden(true)
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
