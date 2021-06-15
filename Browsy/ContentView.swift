//
//  ContentView.swift
//  Browsy
//
//  Created by julionb on 10/06/21.
//

import SwiftUI

struct ContentView: View {
    
    let url: URL
    let browsers: [Bundle]
    
    var body: some View {
        
        let template = "Hello, world! %@"
        
        VStack {
            Text(String(format: template, url.absoluteString))
                .padding()
            List(browsers, id: \.bundleIdentifier) { bundle in
                HStack {
                    Text(bundle.bundleIdentifier ?? "none")
                    Button("OPEN") {
                        openInSpecificBrowser(url: url, bundleUrl: bundle.bundleURL)
                    }
                }
            }
        }
    }
    
    func openInSpecificBrowser(url: URL, bundleUrl: URL) -> () {
        NSWorkspace.shared.open(
            [url],
            withApplicationAt: bundleUrl,
            configuration: NSWorkspace.OpenConfiguration.init(),
            completionHandler: { _, _ in
                return
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            url: URL(string: "www.apple.com")!,
            browsers: [Bundle]()
        )
    }
}
