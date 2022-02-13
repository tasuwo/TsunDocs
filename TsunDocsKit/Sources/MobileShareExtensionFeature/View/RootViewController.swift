//
//  Copyright © 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import MobileShareExtensionUIKit
import SwiftUI

public class RootViewController: UIViewController {
    // MARK: - Properties

    private var dependencyContainer: DependencyContainer!

    // MARK: - View Life-Cycle Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        guard let context = extensionContext else {
            fatalError("Failed to read extensionContext")
        }

        dependencyContainer = DependencyContainer(context)
        let store = Store(initialState: SharedUrlEditViewState(),
                          dependency: dependencyContainer,
                          reducer: SharedUrlEditViewReducer())
        let rootView = SharedUrlEditView(ViewStore(store: store))
            .environment(\.tagControlViewStoreBuilder, dependencyContainer)

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