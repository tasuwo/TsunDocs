//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.load(URLRequest(url: url))
        return view
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // NOP
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_unwrapping
        WebView(url: URL(string: "https://www.apple.com")!)
            .ignoresSafeArea()
    }
}
