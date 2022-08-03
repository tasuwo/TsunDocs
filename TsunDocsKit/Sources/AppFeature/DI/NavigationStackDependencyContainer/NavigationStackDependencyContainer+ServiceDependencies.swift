//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import CoreDataCloudKitHelper
import Domain
import Environment
import MobileSettingFeature
import UIKit

extension NavigationStackDependencyContainer: HasPasteboard {
    // MARK: - HasPasteboard

    public var pasteboard: Pasteboard { UIPasteboard.general }
}

extension NavigationStackDependencyContainer: HasTsundocQueryService {
    // MARK: - HasTsundocQueryService

    public var tsundocQueryService: TsundocQueryService { sceneDependencyContainer.tsundocQueryService }
}

extension NavigationStackDependencyContainer: HasTagQueryService {
    // MARK: - HasTagQueryService

    public var tagQueryService: TagQueryService { sceneDependencyContainer.tagQueryService }
}

extension NavigationStackDependencyContainer: HasTsundocCommandService {
    // MARK: - HasTsundocCommandService

    public var tsundocCommandService: TsundocCommandService { sceneDependencyContainer.tsundocCommandService }
}

extension NavigationStackDependencyContainer: HasTagCommandService {
    // MARK: - HasTagCommandService

    public var tagCommandService: TagCommandService { sceneDependencyContainer.tagCommandService }
}

extension NavigationStackDependencyContainer: HasUserSettingStorage {
    // MARK: - HasUserSettingStorage

    public var userSettingStorage: UserSettingStorage { sceneDependencyContainer.userSettingStorage }
}

extension NavigationStackDependencyContainer: HasCloudKitAvailabilityObserver {
    // MARK: - HasCloudKitAvailabilityObserver

    public var cloudKitAvailabilityObserver: CloudKitAvailabilityObservable { sceneDependencyContainer.cloudKitAvailabilityObserver }
}

extension NavigationStackDependencyContainer: HasWebPageMetaResolver {
    // MARK: - HasWebPageMetaResolver

    public var webPageMetaResolver: WebPageMetaResolvable { sceneDependencyContainer.webPageMetaResolver }
}

extension NavigationStackDependencyContainer: HasNop {}
