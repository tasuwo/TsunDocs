//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public struct BarMenuStyle: MenuStyle {
    // MARK: - Initializers

    public init() {}

    // MARK: - ButtonStyle

    public func makeBody(configuration: Self.Configuration) -> some View {
        Menu(configuration)
            .frame(minWidth: 44, minHeight: 44)
    }
}

struct BarMenuStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HStack {
                Menu {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                    }
                }
                .menuStyle(BarMenuStyle())

                Menu {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "ellipsis")
                    }
                }
                .menuStyle(BarMenuStyle())

                Menu {
                    // NOP
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                    }
                }
                .menuStyle(BarMenuStyle())
                .disabled(true)
            }
        }
    }
}
