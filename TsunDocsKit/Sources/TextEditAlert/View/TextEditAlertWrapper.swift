//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI
import UIKit

struct TextEditAlertWrapper {
    typealias Coordinator = TextEditAlertCoordinator

    @Binding var isPresenting: Bool

    let text: String
    let config: TextEditAlertConfig
}

extension TextEditAlertWrapper: UIViewControllerRepresentable {
    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> TextEditAlertCoordinator {
        return Coordinator(config: config) { isPresenting = false }
    }

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.update(config)

        if !isPresenting, uiViewController.isPresenting(context.coordinator.presentingAlert) {
            context.coordinator.dismiss(animated: true, completion: nil)
            return
        }

        if isPresenting, !uiViewController.isPresenting(context.coordinator.presentingAlert) {
            context.coordinator.present(text: text, on: uiViewController)
            return
        }
    }
}

private extension UIViewController {
    func isPresenting(_ viewController: UIViewController?) -> Bool {
        guard let presentedViewController = presentedViewController else { return false }
        return presentedViewController == viewController
    }
}
