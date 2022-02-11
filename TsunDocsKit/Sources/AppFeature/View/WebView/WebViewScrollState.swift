//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

class WebViewScrollState: NSObject {
    var isNavigationBarHidden: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }

    var isToolbarHidden: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }

    private var previousOffset: CGPoint?
}

extension WebViewScrollState: ObservableObject {}

extension WebViewScrollState: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        previousOffset = nil
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        defer {
            previousOffset = scrollView.contentOffset
        }

        guard let previousContentOffset = previousOffset else {
            return
        }

        if scrollView.contentOffset.y < -scrollView.contentInset.top {
            // 上方向にバウンスする
            withAnimation {
                self.isNavigationBarHidden = false
            }
            return
        } else if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
            // 下方向にバウンスする
            return
        }

        let delta = scrollView.contentOffset.y - previousContentOffset.y
        guard abs(delta) > 8 else { return }
        guard scrollView.isDragging else { return }

        withAnimation {
            if delta > 0 {
                self.isNavigationBarHidden = true
                self.isToolbarHidden = true
            } else {
                self.isNavigationBarHidden = false
                self.isToolbarHidden = false
            }
        }
    }
}
