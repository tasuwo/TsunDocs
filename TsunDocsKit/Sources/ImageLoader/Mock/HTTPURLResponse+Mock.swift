//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

#if DEBUG

// swiftlint:disable force_unwrapping

import Foundation

public extension HTTPURLResponse {
    static let mock_success = HTTPURLResponse(url: URL(string: "https://localhost")!,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)!
    static let mock_failure = HTTPURLResponse(url: URL(string: "https://localhost")!,
                                              statusCode: 404,
                                              httpVersion: nil,
                                              headerFields: nil)!
}

#endif
