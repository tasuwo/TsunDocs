//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

extension Array where Element: Identifiable & Equatable & Hashable {
    func indexed() -> [Element.ID: Ordered<Element>] {
        return self.enumerated().reduce(into: [Element.ID: Ordered<Element>]()) { dict, keyValue in
            dict[keyValue.element.id] = .init(index: keyValue.offset, value: keyValue.element)
        }
    }
}
