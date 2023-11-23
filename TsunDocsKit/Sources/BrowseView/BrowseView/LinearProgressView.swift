//
//  Copyright ©︎ 2023 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

struct LinearProgressView: View {
    let value: CGFloat
    let total: CGFloat

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .trailing) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.gray.opacity(0.8))

                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(minWidth: 0,
                               idealWidth: geometry.size.width * value,
                               maxWidth: geometry.size.width * value)
                }
            }
        }
    }

    func getProgressBarWidth(geometry: GeometryProxy) -> CGFloat {
        let frame = geometry.frame(in: .global)
        return frame.size.width * value
    }
}
