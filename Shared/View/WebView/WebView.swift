//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import SwiftUI
import WebKit

struct WebView {
    typealias Coordinator = WebViewCoordinator

    enum Action {
        case goBack
        case goForward
        case reload
        case stopLoading
    }

    // MARK: - Properties

    let url: URL
    let internalWebView = WKWebView()

    @Binding var action: Action?

    @Binding var title: String?
    @Binding var currentUrl: URL?
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var isLoading: Bool
    @Binding var estimatedProgress: Double
}

#if os(iOS)
    extension WebView: UIViewRepresentable {
        // MARK: - UIViewRepresentable

        func makeCoordinator() -> Coordinator {
            return Coordinator(self)
        }

        func makeUIView(context: Context) -> WKWebView {
            internalWebView.uiDelegate = context.coordinator
            internalWebView.navigationDelegate = context.coordinator
            internalWebView.allowsBackForwardNavigationGestures = true

            let request = URLRequest(url: url)
            internalWebView.load(request)

            return internalWebView
        }

        func updateUIView(_ uiView: WKWebView, context: Context) {
            switch action {
            case .goBack:
                uiView.goBack()

            case .goForward:
                uiView.goForward()

            case .reload:
                uiView.reload()

            case .stopLoading:
                uiView.stopLoading()

            case .none:
                break
            }
            action = nil
        }

        static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
            coordinator.progressObservation?.invalidate()
            coordinator.loadingObservation?.invalidate()
            coordinator.progressObservation = nil
            coordinator.loadingObservation = nil
        }
    }

#elseif os(macOS)
    extension WebView: NSViewRepresentable {
        // MARK: - NSViewRepresentable

        func makeCoordinator() -> Coordinator {
            return Coordinator(self)
        }

        func makeNSView(context: Context) -> WKWebView {
            internalWebView.uiDelegate = context.coordinator
            internalWebView.navigationDelegate = context.coordinator
            internalWebView.allowsBackForwardNavigationGestures = true

            let request = URLRequest(url: url)
            internalWebView.load(request)

            return internalWebView
        }

        func updateNSView(_ nsView: WKWebView, context: Context) {
            switch action {
            case .goBack:
                nsView.goBack()

            case .goForward:
                nsView.goForward()

            case .reload:
                nsView.reload()

            case .stopLoading:
                nsView.stopLoading()

            case .none:
                break
            }
            action = nil
        }

        static func dismantleNSView(_ nsView: WKWebView, coordinator: Coordinator) {
            coordinator.progressObservation?.invalidate()
            coordinator.loadingObservation?.invalidate()
            coordinator.progressObservation = nil
            coordinator.loadingObservation = nil
        }
    }
#endif

struct WebView_Previews: PreviewProvider {
    struct Container: View {
        let baseUrl: URL

        @State var action: WebView.Action?

        @State var title: String?
        @State var currentUrl: URL?
        @State var canGoBack = false
        @State var canGoForward = false
        @State var isLoading = false
        @State var estimatedProgress: Double = 0

        var body: some View {
            VStack {
                Text("title: \(title ?? "-")")
                Text("url: \(currentUrl?.absoluteString ?? "-")")
                Text("isLoading: \(isLoading ? "true" : "false")")
                Text("Progress: \(estimatedProgress)")

                HStack {
                    Button {
                        action = .goBack
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .disabled(!canGoBack)

                    Spacer()

                    Button {
                        action = .goForward
                    } label: {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(!canGoForward)

                    Spacer()

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
                .padding()

                WebView(url: baseUrl,
                        action: $action,
                        title: $title,
                        currentUrl: $currentUrl,
                        canGoBack: $canGoBack,
                        canGoForward: $canGoForward,
                        isLoading: $isLoading,
                        estimatedProgress: $estimatedProgress)
            }
        }
    }

    static var previews: some View {
        // swiftlint:disable:next force_unwrapping
        Container(baseUrl: URL(string: "https://www.apple.com")!)
    }
}
