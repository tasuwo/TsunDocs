//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import MobileShareExtensionFeature
import UIKit

@objc(ShareRootViewController)
class ShareRootViewController: UIViewController {
    // MARK: - View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        let appBundleUrl = Bundle.main.bundleURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        guard let appBundle = Bundle(url: appBundleUrl) else {
            fatalError("Failed to resolve app bundle.")
        }

        guard let context = extensionContext else {
            fatalError("Failed to read extensionContext")
        }

        let dependencyContainer = DependencyContainer(appBundle: appBundle, context: context)

        let viewController = RootViewController()
        viewController.dependencyContainer = dependencyContainer
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
