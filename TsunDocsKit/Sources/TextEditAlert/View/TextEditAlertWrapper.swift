//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI
import UIKit

struct TextEditAlertWrapper<Content: View>: View {
    // MARK: - Properties

    @Binding var isPresenting: Bool

    let content: Content
    let text: String
    let config: TextEditAlertConfig

    // MARK: - View

    var body: some View {
        ZStack {
            if isPresenting {
                TextEditAlert(text: text, config: config) {
                    isPresenting = false
                }
                // HACK: alert表示先のViewサイズに影響を与えないよう、サイズ0で固定する
                .frame(width: 0, height: 0)
                .fixedSize()
            } else {
                EmptyView()
            }

            content
        }
    }
}
