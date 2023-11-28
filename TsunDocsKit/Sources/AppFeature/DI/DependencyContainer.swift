//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Domain
import Environment
import MobileSettingFeature
import UIKit

public typealias DependencyContainer = HasPasteboard
    & HasTsundocQueryService
    & HasTagQueryService
    & HasTsundocCommandService
    & HasTagCommandService
    & HasUserSettingStorage
    & HasCloudKitAvailabilityObserver
    & HasWebPageMetaResolver
    & HasNop
    & HasSharedUserSettingStorage
