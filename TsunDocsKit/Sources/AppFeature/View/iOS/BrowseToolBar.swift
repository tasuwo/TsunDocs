//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Foundation
import SwiftUI

struct BrowseToolBar<Content>: View where Content: View {
    private let preferredHeight: CGFloat = 48

    private let contentProvider: () -> Content

    // MARK: - Initializers

    public init(@ViewBuilder _ provider: @escaping () -> Content) {
        contentProvider = provider
    }

    // MARK: - View

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            ZStack {
                Color(uiColor: UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.bottom)

                HStack {
                    contentProvider()
                }
                .padding([.leading, .trailing], 16)
            }
            .frame(height: preferredHeight)
        }
    }
}

struct BrowseToolBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.white
            BrowseToolBar {
                Button {
                    // NOP
                } label: {
                    Image(systemName: "chevron.left")
                }

                Spacer()

                Button {
                    // NOP
                } label: {
                    Image(systemName: "chevron.right")
                }

                Spacer()

                Button {
                    // NOP
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }

                Spacer()

                Menu {
                    Button {
                        // NOP
                    } label: {
                        Label {
                            Text(L10n.browseViewButtonSafari)
                        } icon: {
                            Image(systemName: "safari")
                        }
                    }

                    Button {
                        // NOP
                    } label: {
                        Label {
                            Text(L10n.browseViewButtonEdit)
                        } icon: {
                            Image(systemName: "pencil")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding([.top, .bottom])
                }
            }
        }
    }
}
