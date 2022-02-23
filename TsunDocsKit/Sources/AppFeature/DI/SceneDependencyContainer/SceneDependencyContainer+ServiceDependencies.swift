//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import UIKit

extension SceneDependencyContainer: HasPasteboard {
    // MARK: - HasPasteboard

    public var pasteboard: Pasteboard { UIPasteboard.general }
}

extension SceneDependencyContainer: HasTsundocQueryService {
    // MARK: - HasTsundocQueryService

    public var tsundocQueryService: TsundocQueryService { appDependencyContainer.tsundocQueryService }
}

extension SceneDependencyContainer: HasTagQueryService {
    // MARK: - HasTagQueryService

    public var tagQueryService: TagQueryService { appDependencyContainer.tagQueryService }
}

extension SceneDependencyContainer: HasTsundocCommandService {
    // MARK: - HasTsundocCommandService

    public var tsundocCommandService: TsundocCommandService { appDependencyContainer.tsundocCommandService }
}

extension SceneDependencyContainer: HasTagCommandService {
    // MARK: - HasTagCommandService

    public var tagCommandService: TagCommandService { appDependencyContainer.tagCommandService }
}

extension SceneDependencyContainer: HasNop {}
