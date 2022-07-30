//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import ButtonStyle
import SwiftUI

struct EmptyMessageView: View {
    // MARK: - Properties

    let title: String
    let message: String?
    let actionButtonTitle: String?
    let onTapActionButton: (() -> Void)?

    // MARK: - Initializers

    init(_ title: String,
         message: String? = nil,
         actionButtonTitle: String? = nil,
         onTapActionButton: (() -> Void)? = nil)
    {
        self.title = title
        self.message = message
        self.actionButtonTitle = actionButtonTitle
        self.onTapActionButton = onTapActionButton
    }

    // MARK: - View

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(title)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .font(.headline)

            if let message = message {
                Text(message)
                    .foregroundColor(.gray)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }

            if let actionButtonTitle = actionButtonTitle {
                Button {
                    onTapActionButton?()
                } label: {
                    Text(actionButtonTitle)
                }
                .buttonStyle(ActionButtonStyle())
            }

            Spacer()
        }
        .padding([.leading, .trailing], 16)
    }
}

struct EmptyMessageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyMessageView("Title",
                             message: "Message",
                             actionButtonTitle: "Action",
                             onTapActionButton: {})

            EmptyMessageView(String(repeating: "Title", count: 30),
                             message: String(repeating: "Message", count: 30),
                             actionButtonTitle: String(repeating: "Action", count: 10),
                             onTapActionButton: {})
        }
    }
}
