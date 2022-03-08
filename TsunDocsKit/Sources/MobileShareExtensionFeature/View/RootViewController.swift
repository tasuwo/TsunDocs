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
    private let indicatorView = UIActivityIndicatorView()

    // MARK: - View Life-Cycle Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureViewHierarchy()

        indicatorView.startAnimating()
        dependencyContainer.urlLoader.load { [weak self] url in
            guard let self = self else { return }
            Task { @MainActor in
                guard let url = url else {
                    self.didFailedToLoad()
                    return
                }
                self.indicatorView.stopAnimating()
                self.didLoad(url)
            }
        }
    }
}

extension RootViewController {
    private func didLoad(_ url: URL) {
        let store = Store(initialState: TsundocCreateViewState(url: url),
                          dependency: dependencyContainer,
                          reducer: TsundocCreateViewReducer())
        let rootView = TsundocCreateView(ViewStore(store: store)) { [dependencyContainer] isSucceeded in
            if isSucceeded {
                dependencyContainer?.context.completeRequest(returningItems: nil, completionHandler: nil)
            } else {
                let error = NSError(domain: "net.tasuwo.tsundocs", code: 0)
                dependencyContainer?.context.cancelRequest(withError: error)
            }
        }
        .environment(\.tagMultiSelectionSheetBuilder, dependencyContainer)

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

    private func didFailedToLoad() {
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("shared_url_edit_view_error_title_load_url", bundle: Bundle.module, comment: ""),
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("alert_close", bundle: Bundle.module, comment: ""), style: .default) { [weak self] _ in
            let error = NSError(domain: "net.tasuwo.tsundocs", code: 0)
            self?.dependencyContainer?.context.cancelRequest(withError: error)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension RootViewController {
    private func configureViewHierarchy() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.backgroundColor = .systemBackground
    }
}
