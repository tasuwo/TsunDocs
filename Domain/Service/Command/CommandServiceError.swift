//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public enum CommandServiceError: Error {
    case duplicated
    case invalidParameter
    case internalError(Error)
}
