//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI
import UIKit

struct TextEditAlert {
    let text: String
    let config: TextEditAlertConfig
    let completion: () -> Void
}

extension TextEditAlert: UIViewControllerRepresentable {
    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> UIViewController {
        return TextEditAlertViewController(config: config, text: text, completion: completion)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // NOP
    }
}
