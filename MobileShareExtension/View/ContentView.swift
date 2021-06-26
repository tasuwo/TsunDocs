//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var loader: SharedUrlLoader

    var body: some View {
        VStack {
            if let url = loader.url {
                Text(url.absoluteString)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.load()
        }
    }
}
