//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import SwiftUI
import UIKit

class TextEditAlertViewController: UIViewController {
    typealias Store = CompositeKit.Store<TextEditAlertState, TextEditAlertAction, TextEditAlertDependency>

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
    private let text: String
    private let completion: () -> Void
    private let dependency: Dependency
    private var subscriptions: Set<AnyCancellable> = .init()

    private(set) weak var presentingAlert: UIAlertController?
    private weak var presentingSaveAction: UIAlertAction?

    // MARK: - Initializers

    init(config: TextEditAlertConfig,
         text: String,
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
        self.text = text
        self.completion = completion

        super.init(nibName: nil, bundle: nil)

        bind()

        update(config)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentAlert()
    }

    // MARK: - Methods

    private func setupAppearance() {
        self.view.backgroundColor = .clear
    }

    private func update(_ config: TextEditAlertConfig) {
        dependency.validator = config.validator
        dependency.saveAction = config.saveAction
        dependency.cancelAction = config.cancelAction
        store.execute(.configUpdated(title: config.title,
                                     message: config.message,
                                     placeholder: config.placeholder))
    }

    private func presentAlert() {
        guard presentingAlert == nil else { return }

        let alert = UIAlertController(title: store.stateValue.title,
                                      message: store.stateValue.message,
                                      preferredStyle: .alert)

        store.execute(.textChanged(text: text))

        let saveAction = UIAlertAction(title: NSLocalizedString("save", bundle: Bundle.this, comment: ""), style: .default) { [weak self] _ in
            self?.store.execute(.saveActionTapped)
            self?.completion()
        }
        alert.addAction(saveAction)
        saveAction.isEnabled = store.stateValue.shouldReturn

        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", bundle: Bundle.this, comment: ""), style: .cancel) { [weak self] _ in
            self?.store.execute(.cancelActionTapped)
            self?.completion()
        }
        alert.addAction(cancelAction)

        alert.addTextField { [weak self] textField in
            guard let self = self else { return }
            textField.placeholder = self.store.stateValue.placeholder
            textField.delegate = self
            textField.text = self.store.stateValue.text
            textField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        }

        presentingAlert = alert
        presentingSaveAction = saveAction

        present(alert, animated: true) { [weak self] in
            self?.store.execute(.presented)
        }
    }

    @objc
    private func textFieldDidChange(sender: UITextField) {
        RunLoop.main.perform { [weak self] in
            self?.store.execute(.textChanged(text: sender.text ?? ""))
        }
    }
}

// MARK: - Bind

extension TextEditAlertViewController {
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

extension TextEditAlertViewController: UITextFieldDelegate {
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
