//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CoreDataCloudKitHelper
import Domain
import Environment
import MobileSettingFeature
import UIKit

extension SceneDependencyContainer: DependencyContainer {
    // MARK: - DependencyContainer

    public var pasteboard: Pasteboard { UIPasteboard.general }
    public var tsundocQueryService: TsundocQueryService { appDependencyContainer.tsundocQueryService }
    public var tagQueryService: TagQueryService { appDependencyContainer.tagQueryService }
    public var tsundocCommandService: TsundocCommandService { appDependencyContainer.tsundocCommandService }
    public var tagCommandService: TagCommandService { appDependencyContainer.tagCommandService }
    public var userSettingStorage: UserSettingStorage { appDependencyContainer.userSettingStorage }
    public var cloudKitAvailabilityObserver: CloudKitAvailabilityObservable { appDependencyContainer.cloudKitAvailabilityObserver }
    public var webPageMetaResolver: WebPageMetaResolvable { appDependencyContainer.webPageMetaResolver }
}
