//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

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

    func makeUIViewController(context: Context) -> some UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isPresenting, !uiViewController.isPresenting(context.coordinator.alertController) {
            context.coordinator.present(text: text, on: uiViewController)
        }

        if !isPresenting, uiViewController.isPresenting(context.coordinator.alertController) {
            context.coordinator.dismiss(animated: true, completion: nil)
        }
    }
}

private extension UIViewController {
    func isPresenting(_ viewController: UIViewController?) -> Bool {
        guard let presentedViewController = presentedViewController else { return false }
        return presentedViewController == viewController
    }
}
