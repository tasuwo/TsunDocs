//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import os.log

enum LogHandler {
    static var persistentCloudKitContainer: OSLog = {
        #if DEBUG
        return OSLog(subsystem: "net.tasuwo.tsundocs.TsunDocsKit.Persistence", category: "PersistentCloudKitContainer")
        #else
        return .disabled
        #endif
    }()
}
