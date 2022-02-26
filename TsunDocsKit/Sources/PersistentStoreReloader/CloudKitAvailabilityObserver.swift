//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CloudKit
import Combine

public protocol CloudKitAvailabilityObservable {
    var availability: AnyPublisher<CloudKitAvailability?, Error> { get }
    func availability() async throws -> CloudKitAvailability
}

public class CloudKitAvailabilityObserver {
    private let ckAccountStatusObserver: CKAccountStatusObserver

    private var _availability: CurrentValueSubject<CloudKitAvailability?, Error> = .init(nil)
    private var subscriptions: Set<AnyCancellable> = .init()

    // MARK: - Initializers

    public init(ckAccountStatusObserver: CKAccountStatusObserver) {
        self.ckAccountStatusObserver = ckAccountStatusObserver

        bind()
    }

    // MARK: - Methods

    private func bind() {
        ckAccountStatusObserver.accountStatus
            .compactMap { $0 }
            .sink { [weak self] in
                self?._availability.send(completion: $0)
            } receiveValue: { [weak self] status in
                guard let self = self else { return }
                Task {
                    let id = await Self.resolveAccountId(byStatus: status)
                    let availability = self.resolveCloudAvailability(byAccountId: id)
                    self._availability.send(availability)
                }
            }
            .store(in: &subscriptions)
    }

    private static func resolveAccountId(byStatus status: CKAccountStatus) async -> String? {
        guard case .available = status,
              let id = try? await CKContainer.default().userRecordID() else { return nil }
        return "\(id.zoneID.zoneName)_\(id.recordName)"
    }

    private func resolveCloudAvailability(byAccountId id: String?) -> CloudKitAvailability {
        guard let id = id else { return .unavailable }
        return .available(accountId: id)
    }
}

extension CloudKitAvailabilityObserver: CloudKitAvailabilityObservable {
    // MARK: - CloudKitAvailabilityObservable

    public var availability: AnyPublisher<CloudKitAvailability?, Error> {
        _availability.eraseToAnyPublisher()
    }

    public func availability() async throws -> CloudKitAvailability {
        let status = try await ckAccountStatusObserver.accountStatus()
        let id = await Self.resolveAccountId(byStatus: status)
        return self.resolveCloudAvailability(byAccountId: id)
    }
}
