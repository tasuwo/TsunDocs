//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import MobileShareExtensionUIKit
import Social
import SwiftUI

@objc(ShareRootViewController)
class ShareRootViewController: UIViewController {
    // MARK: - Properties

    private var dependencyContainer: DependencyContainer!

    // MARK: - View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let context = extensionContext else {
            fatalError("Failed to read extensionContext")
        }

        dependencyContainer = DependencyContainer(context)
        let store = Store(initialState: SharedUrlEditViewRootState(),
                          dependency: dependencyContainer,
                          reducer: sharedUrlEditViewRootReducer)
        let rootView = SharedUrlEditView(ViewStore(store: store))
            .environment(\.tagMultiAdditionViewStoreBuilder, dependencyContainer)

        let viewController = UIHostingController(rootView: rootView)
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
