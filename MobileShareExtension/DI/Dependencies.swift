//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

protocol HasSharedUrlLoader {
    var sharedUrlLoader: SharedUrlLoader { get }
}

protocol HasSharedUrlMetaResolver {
    var sharedUrlMetaResolver: SharedUrlMetaResolver { get }
}

protocol HasTsundocCommandService {
    var tsundocCommandService: TsundocCommandService { get }
}
