//
//  Copyright © 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData

public class PersistentContainerMonitor {
    private var disposableBag = Set<AnyCancellable>()

    // MARK: - Initializers

    public init() {}

    // MARK: - Methods

    public func startMonitoring() {
        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .sink { notification in
                guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else {
                    return
                }

                switch event.type {
                case .setup:
                    print("Setup \(event.isStarted ? "started" : "ended")")

                case .import:
                    print("Import \(event.isStarted ? "started" : "ended")")

                case .export:
                    print("Export \(event.isStarted ? "started" : "ended")")

                @unknown default:
                    assertionFailure("Unknown NSPersistentCloudKitContainer.Event")
                }

                if let error = event.error {
                    print("""
                    Filed to iCloud sync. \(error.localizedDescription)
                    - type: \(event.type)
                    - startDate: \(event.startDate)
                    - endDate: \(String(describing: event.endDate))
                    """)
                }
            }
            .store(in: &self.disposableBag)
    }
}

private extension NSPersistentCloudKitContainer.Event {
    var isStarted: Bool {
        return self.endDate == nil
    }
}
