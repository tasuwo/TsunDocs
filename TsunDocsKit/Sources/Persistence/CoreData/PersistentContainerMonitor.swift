//
//  Copyright © 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import CoreData
import os.log

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

                let logger = Logger(LogHandler.persistentCloudKitContainer)
                switch event.type {
                case .setup:
                    logger.log(level: .debug, "Setup \(event.isStarted ? "started" : "ended", privacy: .public)")

                case .import:
                    logger.log(level: .debug, "Import \(event.isStarted ? "started" : "ended", privacy: .public)")

                case .export:
                    logger.log(level: .debug, "Export \(event.isStarted ? "started" : "ended", privacy: .public)")

                @unknown default:
                    assertionFailure("Unknown NSPersistentCloudKitContainer.Event")
                }

                if let error = event.error {
                    logger.log(level: .error, "Failed to iCloud Sync: \(error.localizedDescription)")
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
