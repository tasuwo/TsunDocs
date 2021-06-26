//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

public extension Result {
    var successValue: Success? {
        switch self {
        case let .success(value):
            return value

        case .failure:
            return nil
        }
    }

    var failureValue: Failure? {
        switch self {
        case let .failure(error):
            return error

        case .success:
            return nil
        }
    }
}
