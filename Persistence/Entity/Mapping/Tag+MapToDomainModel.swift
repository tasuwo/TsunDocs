//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

extension Tag {
    func mapToDomainModel() -> Domain.Tag? {
        guard let id = id,
              let name = name
        else {
            return nil
        }

        return .init(id: id, name: name, tsundocsCount: Int(tsundocsCount))
    }
}
