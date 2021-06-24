//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain

public class TagCommandService: CoreDataCommandService {}

extension TagCommandService: Domain.TagCommandService {
    public func createTag(by command: TagCommand) -> Result<Domain.Tag.ID, CommandServiceError> {
        let id = UUID()

        let tag = Tag(context: context)
        tag.id = id
        tag.name = command.name
        let currentDate = Date()
        tag.createdDate = currentDate
        tag.updatedDate = currentDate

        return .success(id)
    }
}
