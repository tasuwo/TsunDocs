//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public protocol TsundocCommandService: Transaction {
    func createTsundoc(by command: TsundocCommand) -> Result<Tsundoc.ID, CommandServiceError>
}
