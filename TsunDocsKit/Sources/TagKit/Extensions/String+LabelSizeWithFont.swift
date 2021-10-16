//
//  Created by Tasuku Tozawa on 2021/10/11.
//

import SwiftUI
import UIKit

extension String {
    func labelSize(withFont font: Font) -> CGSize {
        let label = UILabel()
        label.font = font.uiFont
        label.adjustsFontForContentSizeCategory = true
        label.text = self
        label.sizeToFit()
        return label.frame.size
    }

    static func labelSizeOfSymbol(systemName: String, withFont font: Font) -> CGSize {
        let config = UIImage.SymbolConfiguration(font: font.uiFont)
        let image = UIImage(systemName: systemName, withConfiguration: config)

        let attachment = NSTextAttachment()
        attachment.image = image
        let string = NSMutableAttributedString(attachment: attachment)

        let label = UILabel()
        label.font = font.uiFont
        label.adjustsFontForContentSizeCategory = true
        label.attributedText = string
        label.sizeToFit()

        return label.frame.size
    }
}
