//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    // MARK: - Properties

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    let excludedActivityTypes: [UIActivity.ActivityType]?
    let completionHandler: UIActivityViewController.CompletionWithItemsHandler?

    // MARK: - Initializers

    init(activityItems: [Any],
         applicationActivities: [UIActivity]? = nil,
         excludedActivityTypes: [UIActivity.ActivityType]? = nil,
         completionHandler: UIActivityViewController.CompletionWithItemsHandler? = nil)
    {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.excludedActivityTypes = excludedActivityTypes
        self.completionHandler = completionHandler
    }

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = completionHandler
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // NOP
    }
}

struct ShareSheet_Previews: PreviewProvider {
    struct Container: View {
        @State var isPresented = false

        var body: some View {
            Button {
                isPresented = true
            } label: {
                Text("Hoge")
            }
            .sheet(isPresented: $isPresented) {
                ShareSheet(activityItems: [])
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
