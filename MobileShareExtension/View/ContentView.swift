//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import Domain
import SwiftUI

struct ContentView: View {
    @StateObject var container: DependencyContainer
    @StateObject var loader: SharedUrlLoader

    var body: some View {
        VStack {
            if let url = loader.url {
                Text(url.absoluteString)
                Button("保存") {
                    container.tsundocCommandService.perform {
                        try? container.tsundocCommandService.begin()
                        let command = TsundocCommand(title: "URL Title",
                                                     description: nil,
                                                     url: url,
                                                     thumbnailSource: nil)
                        _ = container.tsundocCommandService.createTsundoc(by: command)
                        try? container.tsundocCommandService.commit()
                    }
                    container.context.completeRequest(returningItems: [], completionHandler: nil)
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.load()
        }
    }
}
