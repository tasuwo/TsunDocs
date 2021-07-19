//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import UIKit

@MainActor
class TextEditAlertCoordinator: NSObject {
    typealias Store = CompositeKit.Store<TextEditAlertState, TextEditAlertAction, TextEditAlertDependency>

    @MainActor
    private class AlertController: UIAlertController {
        var completion: (() -> Void)?
        weak var store: Store?

        deinit {
            Task { [weak store] in await store?.execute(.dismissed) }
            completion?()
        }
    }

    private class Dependency: TextEditAlertDependency {
        var validator: ((String?) -> Bool)?
        var saveAction: ((String) -> Void)?
        var cancelAction: (() -> Void)?

        init(validator: ((String?) -> Bool)?,
             saveAction: ((String) -> Void)?,
             cancelAction: (() -> Void)?)
        {
            self.validator = validator
            self.saveAction = saveAction
            self.cancelAction = cancelAction
        }
    }

    // MARK: - Properties

    private let store: Store
    private let completion: () -> Void
    private let dependency: Dependency
    private var subscriptions: Set<AnyCancellable> = .init()

    private weak var presentingAlert: AlertController?
    private weak var presentingSaveAction: UIAlertAction?

    var alertController: UIAlertController? { presentingAlert }

    // MARK: - Initializers

    init(config: TextEditAlertConfig,
         completion: @escaping () -> Void)
    {
        let state = TextEditAlertState(config)
        let dependency = Dependency(validator: config.validator,
                                    saveAction: config.saveAction,
                                    cancelAction: config.cancelAction)
        self.dependency = dependency

        self.store = .init(initialState: state,
                           dependency: dependency,
                           reducer: TextEditAlertReducer())
        self.completion = completion

        super.init()

        bind()
    }

    // MARK: - Methods

    func update(_ config: TextEditAlertConfig) {
        dependency.validator = config.validator
        dependency.saveAction = config.saveAction
        dependency.cancelAction = config.cancelAction
        store.execute(.configUpdated(title: config.title,
                                     message: config.message,
                                     placeholder: config.placeholder))
    }

    func present(text: String,
                 on viewController: UIViewController)
    {
        guard presentingAlert == nil else { return }

        let alert = AlertController(title: store.stateValue.title,
                                    message: store.stateValue.message,
                                    preferredStyle: .alert)
        alert.completion = completion

        store.execute(.textChanged(text: text))

        let saveAction = UIAlertAction(title: "text_edit_alert_save_action".localized, style: .default) { [weak self] _ in
            self?.store.execute(.saveActionTapped)
        }
        alert.addAction(saveAction)
        saveAction.isEnabled = store.stateValue.shouldReturn

        let cancelAction = UIAlertAction(title: "text_edit_alert_cancel_action".localized, style: .cancel) { [weak self] _ in
            self?.store.execute(.cancelActionTapped)
        }
        alert.addAction(cancelAction)

        alert.addTextField { [weak self] textField in
            guard let self = self else { return }
            textField.placeholder = self.store.stateValue.placeholder
            textField.delegate = self
            textField.text = self.store.stateValue.text
            textField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        }

        alert.store = store
        presentingAlert = alert
        presentingSaveAction = saveAction

        viewController.present(alert, animated: true) { [weak self] in
            self?.store.execute(.presented)
        }
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        presentingAlert?.dismiss(animated: animated, completion: completion)
    }

    @objc
    private func textFieldDidChange(sender: UITextField) {
        RunLoop.main.perform { [weak self] in
            self?.store.execute(.textChanged(text: sender.text ?? ""))
        }
    }
}

// MARK: - Bind

extension TextEditAlertCoordinator {
    func bind() {
        store.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.presentingSaveAction?.isEnabled = state.shouldReturn
            }
            .store(in: &subscriptions)

        store.state
            .receive(on: DispatchQueue.main)
            .bind(\.title) { [weak self] title in
                self?.presentingAlert?.title = title
            }
            .store(in: &subscriptions)

        store.state
            .receive(on: DispatchQueue.main)
            .bind(\.message) { [weak self] message in
                self?.presentingAlert?.message = message
            }
            .store(in: &subscriptions)

        store.state
            .receive(on: DispatchQueue.main)
            .bind(\.placeholder) { [weak self] placeholder in
                self?.presentingAlert?.textFields?.first?.placeholder = placeholder
            }
            .store(in: &subscriptions)
    }
}

// MARK: - UITextFieldDelegate

extension TextEditAlertCoordinator: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return store.stateValue.shouldReturn
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        RunLoop.main.perform { [weak self] in
            self?.store.execute(.textChanged(text: textField.text ?? ""))
        }
        return true
    }
}
