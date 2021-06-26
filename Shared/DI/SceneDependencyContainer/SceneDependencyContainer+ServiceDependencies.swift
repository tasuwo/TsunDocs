//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

extension SceneDependencyContainer: HasTsundocQueryService {
    // MARK: - HasTsundocQueryService

    var tsundocQueryService: TsundocQueryService { appDependencyContainer.tsundocQueryService }
}

extension SceneDependencyContainer: HasTagQueryService {
    // MARK: - HasTagQueryService

    var tagQueryService: TagQueryService { appDependencyContainer.tagQueryService }
}

extension SceneDependencyContainer: HasTsundocCommandService {
    // MARK: - HasTsundocCommandService

    var tsundocCommandService: TsundocCommandService { appDependencyContainer.tsundocCommandService }
}

extension SceneDependencyContainer: HasTagCommandService {
    // MARK: - HasTagCommandService

    var tagCommandService: TagCommandService { appDependencyContainer.tagCommandService }
}
