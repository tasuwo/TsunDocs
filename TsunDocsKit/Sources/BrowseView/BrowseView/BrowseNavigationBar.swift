//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Foundation
import SwiftUI
import UIComponent
import UIKit

struct BrowseNavigationBar<LeadingContent, TrailingContent>: View where LeadingContent: View, TrailingContent: View {
    let preferredHeight: CGFloat = 48

    private let title: String
    private let leadingContentBuilder: () -> LeadingContent
    private let trailingContentBuilder: () -> TrailingContent

    @Environment(\.verticalSizeClass) var verticalSizeClass

    // MARK: - Initializers

    init(title: String,
         @ViewBuilder leading: @escaping () -> LeadingContent,
         @ViewBuilder trailing: @escaping () -> TrailingContent)
    {
        self.title = title
        leadingContentBuilder = leading
        trailingContentBuilder = trailing
    }

    // MARK: - View

    var body: some View {
        ZStack {
            Color(uiColor: UIColor.systemBackground)
                .edgesIgnoringSafeArea(.top)

            HStack(spacing: verticalSizeClass == .compact ? 32 : 8) {
                leadingContentBuilder()
                    .buttonStyle(BarButtonStyle())
                    .menuStyle(BarMenuStyle())

                Spacer()

                Text(title)
                    .bold()
                    .lineLimit(1)
                    .allowsTightening(false)

                Spacer()

                trailingContentBuilder()
                    .buttonStyle(BarButtonStyle())
                    .menuStyle(BarMenuStyle())
            }
            .padding([.leading, .trailing], 16)
            .frame(maxHeight: .infinity)
        }
        .frame(height: preferredHeight)
    }
}

struct BrowseNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: 0) {
                BrowseNavigationBar(title: "Title") {
                    Button {
                        // NOP
                    } label: {
                        Text("browse_view_button_close", bundle: Bundle.module)
                    }
                } trailing: {
                    Button {
                        // NOP
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                Divider()
                Color.white
            }

            VStack {
                BrowseNavigationBar(title: "HogeHogeHogeHogeHogeHogeHogeHogeHoge") {
                    Button {
                        // NOP
                    } label: {
                        Text("browse_view_button_close", bundle: Bundle.module)
                    }
                } trailing: {
                    Button {
                        // NOP
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                Color.white
            }
        }
    }
}
