//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

/// @mockable
public protocol TsundocCommandService: Transaction {
    func createTsundoc(by command: TsundocCommand) -> Result<Tsundoc.ID, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, title: String) -> Result<Void, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, emojiAlias: String?, emojiBackgroundColor: EmojiBackgroundColor?) -> Result<Void, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, byAddingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, byRemovingTagHaving tagId: Tag.ID) -> Result<Void, CommandServiceError>
    func updateTsundoc(having id: Tsundoc.ID, byReplacingTagsHaving tagIds: Set<Tag.ID>) -> Result<Void, CommandServiceError>
    func deleteTsundoc(having id: Tsundoc.ID) -> Result<Void, CommandServiceError>
}

public extension TsundocCommandService {
    @discardableResult
    func createTsundoc(by command: TsundocCommand) async throws -> Domain.Tsundoc.ID {
        try await perform {
            do {
                try begin()

                let result = try createTsundoc(by: command).get()

                try commit()

                return result
            } catch {
                try cancel()
                throw error
            }
        }
    }

    func updateTsundoc(having id: Tsundoc.ID, title: String) async throws {
        try await perform { () -> Void in
            do {
                try begin()

                try updateTsundoc(having: id, title: title).get()

                try commit()
            } catch {
                try cancel()
                throw error
            }
        }
    }

    func updateTsundoc(having id: Tsundoc.ID, emojiAlias: String?, emojiBackgroundColor: EmojiBackgroundColor?) async throws {
        try await perform { () -> Void in
            do {
                try begin()

                try updateTsundoc(having: id, emojiAlias: emojiAlias, emojiBackgroundColor: emojiBackgroundColor).get()

                try commit()
            } catch {
                try cancel()
                throw error
            }
        }
    }

    func updateTsundoc(having id: Tsundoc.ID, byAddingTagHaving tagId: Tag.ID) async throws {
        try await perform { () -> Void in
            do {
                try begin()

                try updateTsundoc(having: id, byAddingTagHaving: tagId).get()

                try commit()
            } catch {
                try cancel()
                throw error
            }
        }
    }

    func updateTsundoc(having id: Tsundoc.ID, byRemovingTagHaving tagId: Tag.ID) async throws {
        try await perform { () -> Void in
            do {
                try begin()

                try updateTsundoc(having: id, byRemovingTagHaving: tagId).get()

                try commit()
            } catch {
                try cancel()
                throw error
            }
        }
    }

    func updateTsundoc(having id: Tsundoc.ID, byReplacingTagsHaving tagIds: Set<Tag.ID>) async throws {
        try await perform { () -> Void in
            do {
                try begin()

                try updateTsundoc(having: id, byReplacingTagsHaving: tagIds).get()

                try commit()
            } catch {
                try cancel()
                throw error
            }
        }
    }

    func deleteTsundoc(having id: Tsundoc.ID) async throws {
        try await perform { () -> Void in
            do {
                try begin()

                try deleteTsundoc(having: id).get()

                try commit()
            } catch {
                try cancel()
                throw error
            }
        }
    }

    func deleteTsundocs(having ids: Set<Tsundoc.ID>) async throws {
        try await perform { () -> Void in
            do {
                try begin()

                try ids.forEach {
                    try deleteTsundoc(having: $0).get()
                }

                try commit()
            } catch {
                try cancel()
                throw error
            }
        }
    }
}
