//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = SFSafariViewController(url: url)
        viewController.dismissButtonStyle = .close
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // NOP
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://www.apple.com")!)
            .ignoresSafeArea()
    }
}
