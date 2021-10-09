//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import Foundation

public class TextEngine: ObservableObject {
    @Published public var input = ""
    @Published public var output = ""

    private var cancellable: AnyCancellable?

    public init(debounceFor time: TimeInterval) {
        cancellable = $input
            .debounce(for: RunLoop.SchedulerTimeType.Stride(time), scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: \.output, on: self)
    }
}
