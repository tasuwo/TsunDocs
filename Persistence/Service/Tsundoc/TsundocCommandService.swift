//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public class TsundocCommandService: CoreDataCommandService {}

extension TsundocCommandService: Domain.TsundocCommandService {
    public func createTsundoc(by command: TsundocCommand) -> Result<Domain.Tsundoc.ID, CommandServiceError> {
        let id = UUID()

        let tsundoc = Tsundoc(context: context)
        tsundoc.id = id
        tsundoc.title = command.title
        tsundoc.descriptionText = command.description
        tsundoc.url = command.url

        switch command.thumbnailSource {
        case let .emoji(alias):
            tsundoc.emojiAlias = alias

        case let .imageUrl(url):
            tsundoc.imageUrl = url

        case .none:
            break
        }

        let currentDate = Date()
        tsundoc.createdDate = currentDate
        tsundoc.updatedDate = currentDate

        return .success(id)
    }
}
