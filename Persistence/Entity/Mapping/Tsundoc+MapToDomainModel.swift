//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

extension Tsundoc {
    func mapToDomainModel() -> Domain.Tsundoc? {
        guard let id = id,
              let title = title,
              let url = url,
              let createdDate = createdDate,
              let updatedDate = updatedDate
        else {
            return nil
        }

        return .init(id: id,
                     title: title,
                     description: descriptionText,
                     url: url,
                     imageUrl: imageUrl,
                     emojiAlias: emojiAlias,
                     updatedDate: updatedDate,
                     createdDate: createdDate)
    }
}