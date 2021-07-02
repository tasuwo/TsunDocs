//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

struct Emoji: Searchable {
    let alias: String
    let emoji: String
    let searchableText: String?

    var id: String { alias }
}
