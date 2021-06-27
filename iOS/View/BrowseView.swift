//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

struct BrowseView: View {
    // MARK: - Properties

    let baseUrl: URL

    @State var action: WebView.Action?

    @State var title: String?
    @State var currentUrl: URL?
    @State var canGoBack = false
    @State var canGoForward = false
    @State var isLoading = false
    @State var estimatedProgress: Double = 0

    @State var isPresentShareSheet = false

    @Environment(\.openURL) var openURL

    // MARK: - View

    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                ProgressView(value: estimatedProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
            }
            WebView(url: baseUrl,
                    action: $action,
                    title: $title,
                    currentUrl: $currentUrl,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    isLoading: $isLoading,
                    estimatedProgress: $estimatedProgress)
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
        }
        .toolbar {
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
                .disabled(!canGoBack || isLoading)

                Spacer()

                Button {
                    action = .goForward
                } label: {
                    Image(systemName: "chevron.right")
                }
                .disabled(!canGoForward || isLoading)

                Spacer()

                Button {
                    isPresentShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(currentUrl == nil)

                Spacer()

                Button {
                    guard let url = currentUrl else { return }
                    openURL(url)
                } label: {
                    Image(systemName: "safari")
                }
                .disabled(currentUrl == nil)
            }
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // swiftlint:disable:next force_unwrapping
            BrowseView(baseUrl: URL(string: "https://www.apple.com")!)
        }
    }
}
