//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import WebKit

class WebViewCoordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
    // MARK: - Properties

    let parent: WebView

    var progressObservation: NSKeyValueObservation?
    var loadingObservation: NSKeyValueObservation?

    // MARK: - Initializers

    init(_ parent: WebView) {
        self.parent = parent

        progressObservation = parent.internalWebView.observe(\.estimatedProgress, options: .new) { _, change in
            parent.estimatedProgress = change.newValue ?? 0
        }
        loadingObservation = parent.internalWebView.observe(\.isLoading, options: .new) { _, change in
            parent.isLoading = change.newValue ?? false
        }
    }

    // MARK: - WKUIDelegate

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let targetFrame = navigationAction.targetFrame,
              targetFrame.isMainFrame
        else {
            webView.load(navigationAction.request)
            return nil
        }
        return nil
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.parent.title = webView.title
        self.parent.currentUrl = webView.url
        self.parent.canGoBack = webView.canGoBack
        self.parent.canGoForward = webView.canGoForward
    }
}
