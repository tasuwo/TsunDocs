//
//  Copyright © 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import SwiftUI
import TsundocCreateFeature

public class RootViewController: UIViewController {
    // MARK: - Properties

    public var dependencyContainer: DependencyContainer!
    private var cancellables: Set<AnyCancellable> = .init([])

    // MARK: - View Life-Cycle Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        let store = Store(initialState: TsudocCreateViewState(),
                          dependency: dependencyContainer,
                          reducer: TsundocCreateViewReducer())
        let rootView = TsundocCreateView(ViewStore(store: store))
            .environment(\.tagMultiSelectionSheetBuilder, dependencyContainer)

        store.state
            .compactMap(\.saveResult)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [dependencyContainer] result in
                switch result {
                case .succeeded:
                    dependencyContainer?.context.completeRequest(returningItems: nil, completionHandler: nil)

                case .failed:
                    let error = NSError(domain: "net.tasuwo.tsundocs", code: 0)
                    dependencyContainer?.context.cancelRequest(withError: error)
                }
            }
            .store(in: &cancellables)

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
