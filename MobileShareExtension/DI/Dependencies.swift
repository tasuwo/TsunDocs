//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

protocol HasSharedUrlLoader {
    var sharedUrlLoader: SharedUrlLoader { get }
}

protocol HasWebPageMetaResolver {
    var webPageMetaResolver: WebPageMetaResolver { get }
}

protocol HasTsundocCommandService {
    var tsundocCommandService: TsundocCommandService { get }
}
