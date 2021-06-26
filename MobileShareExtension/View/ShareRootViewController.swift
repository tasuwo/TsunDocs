//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Social
import SwiftUI

@objc(ShareRootViewController)
class ShareRootViewController: UIViewController {
    // MARK: - View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let context = extensionContext else {
            fatalError("Failed to read extensionContext")
        }

        let rootView = ContentView(loader: SharedUrlLoader(context))
        let viewController = UIHostingController(rootView: rootView)
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
