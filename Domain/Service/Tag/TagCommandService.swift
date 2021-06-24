//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol TagCommandService: Transaction {
    func createTag(by command: TagCommand) -> Result<Tag.ID, CommandServiceError>
}
