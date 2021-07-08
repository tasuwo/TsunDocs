//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

struct TextEditAlertWrapper<Content: View> {
    typealias Coordinator = TextEditAlertCoordinator

    @Binding var isPresenting: Bool

    let text: String
    let content: Content
    let config: TextEditAlertConfig
}

extension TextEditAlertWrapper: UIViewControllerRepresentable {
    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> TextEditAlertCoordinator {
        return Coordinator(config: config) { isPresenting = false }
    }

    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        UIHostingController(rootView: content)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.rootView = content
        context.coordinator.update(config)

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
