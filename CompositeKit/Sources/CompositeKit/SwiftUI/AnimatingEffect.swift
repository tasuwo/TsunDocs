//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Combine
import SwiftUI

public class AnimatingEffect<Action: CompositeKit.Action>: Effect<Action> {
    public init<P: Publisher>(_ publisher: P,
                              completeWith action: Action? = nil,
                              animateWith animation: Animation? = nil) where P.Output == Action?, P.Failure == Never
    {
        super.init(publisher, completeWith: action, dispatchWith: { withAnimation(animation, $0) })
    }

    public init<P: Publisher>(_ publisher: P,
                              underlying object: Any?,
                              completeWith action: Action? = nil,
                              animateWith animation: Animation? = nil) where P.Output == Action?, P.Failure == Never
    {
        super.init(publisher, underlying: object, completeWith: action, dispatchWith: { withAnimation(animation, $0) })
    }

    public init<P: Publisher>(id: UUID,
                              publisher: P,
                              underlying object: Any?,
                              completeWith action: Action? = nil,
                              animateWith animation: Animation? = nil) where P.Output == Action?, P.Failure == Never
    {
        super.init(id: id, publisher: publisher, underlying: object, completeWith: action, dispatchWith: { withAnimation(animation, $0) })
    }

    public init(value action: Action, animateWith animation: Animation? = nil) {
        super.init(value: action, dispatchWith: { withAnimation(animation, $0) })
    }

    public init(_ block: @escaping () async -> Action?, animateWith animation: Animation? = nil) {
        super.init(block, dispatchWith: { withAnimation(animation, $0) })
    }
}
