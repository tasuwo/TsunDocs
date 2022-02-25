//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine

public protocol ICloudSyncSettingStorage {
    var isiCloudSyncEnabled: AnyPublisher<Bool, Never> { get }
    func set(isiCloudSyncEnabled: Bool)
}
