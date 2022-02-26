//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CloudKit
import Combine

public protocol CKAccountStatusObservable {
    var accountStatus: AnyPublisher<CKAccountStatus?, Error> { get }
    func accountStatus() async throws -> CKAccountStatus
}

public class CKAccountStatusObserver {
    // MARK: - Properties

    private let _accountStatus: CurrentValueSubject<CKAccountStatus?, Error> = .init(nil)
    private var subscriptions: Set<AnyCancellable> = .init()

    // MARK: - Initializers

    public init() {
        updateAccountStatus()

        NotificationCenter
            .Publisher(center: .default, name: .CKAccountChanged)
            .sink { [weak self] _ in self?.updateAccountStatus() }
            .store(in: &self.subscriptions)
    }

    // MARK: - Methods

    private func updateAccountStatus() {
        Task {
            do {
                let accountStatus = try await CKContainer.default().accountStatus()
                _accountStatus.send(accountStatus)
            } catch {
                _accountStatus.send(completion: .failure(error))
            }
        }
    }
}

extension CKAccountStatusObserver: CKAccountStatusObservable {
    // MARK: - CKAccountStatusObservable

    public var accountStatus: AnyPublisher<CKAccountStatus?, Error> {
        _accountStatus.eraseToAnyPublisher()
    }

    public func accountStatus() async throws -> CKAccountStatus {
        return try await CKContainer.default().accountStatus()
    }
}
