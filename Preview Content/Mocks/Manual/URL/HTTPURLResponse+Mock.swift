//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    static let mock_success = HTTPURLResponse(url: URL(string: "https://localhost")!,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)!
    static let mock_failure = HTTPURLResponse(url: URL(string: "https://localhost")!,
                                              statusCode: 404,
                                              httpVersion: nil,
                                              headerFields: nil)!
}
