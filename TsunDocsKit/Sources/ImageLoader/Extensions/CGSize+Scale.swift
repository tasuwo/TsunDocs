//
//  Copyright ©︎ 2021 Tasuku Tozawa. All rights reserved.
//

import CoreGraphics

public extension CGSize {
    func scaled(_ scale: CGFloat) -> CGSize {
        return CGSize(width: width * scale, height: height * scale)
    }

    func aspectFit(to size: CGSize) -> CGSize {
        let widthScale = size.width / width
        let heightScale = size.height / height
        return scaled(min(widthScale, heightScale))
    }

    func aspectFill(to size: CGSize) -> CGSize {
        let widthScale = size.width / width
        let heightScale = size.height / height
        return scaled(max(widthScale, heightScale))
    }
}
