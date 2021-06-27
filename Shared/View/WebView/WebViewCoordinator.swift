//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import WebKit

class WebViewCoordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
    // MARK: - Properties

    let parent: WebView

    var observations: [NSKeyValueObservation]

    // MARK: - Initializers

    init(_ parent: WebView) {
        self.parent = parent

        let progressObservation = parent.internalWebView.observe(\.estimatedProgress, options: .new) { _, change in
            guard let newValue = change.newValue else { return }
            parent.estimatedProgress = newValue
        }

        let loadingObservation = parent.internalWebView.observe(\.isLoading, options: .new) { _, change in
            guard let newValue = change.newValue else { return }
            parent.isLoading = newValue
        }

        let canGoBackObservation = parent.internalWebView.observe(\.canGoBack, options: .new) { _, change in
            guard let newValue = change.newValue else { return }
            parent.canGoBack = newValue
        }

        let canGoForwardObservation = parent.internalWebView.observe(\.canGoForward, options: .new) { _, change in
            guard let newValue = change.newValue else { return }
            parent.canGoForward = newValue
        }

        self.observations = [
            progressObservation,
            loadingObservation,
            canGoBackObservation,
            canGoForwardObservation
        ]
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
    }
}
