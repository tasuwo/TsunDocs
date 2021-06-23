//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public enum QueryServiceError: Error {
    case notFound
    case internalError(Error)
}
