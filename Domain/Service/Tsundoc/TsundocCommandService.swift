//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

/// @mockable
public protocol TsundocCommandService: Transaction {
    func createTsundoc(by command: TsundocCommand) -> Result<Tsundoc.ID, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, byAddingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, byRemovingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, byReplacingTagsHaving tagID: Set<Tag.ID>) -> Result<Void, CommandServiceError>
    func deleteTsundoc(having id: Tsundoc.ID) -> Result<Void, CommandServiceError>
}
