//
//  ContentView.swift
//  Browsy
//
//  Created by julionb on 10/06/21.
//

import SwiftUI

struct ContentView: View {
    
    let url: URL?
    let browsers: [Bundle]
    
    var body: some View {
        
        let template = "Hello, world! %@"
        
        VStack {
            Text(String(format: template, url?.absoluteString ?? "null"))
                .padding()
            List(browsers, id: \.bundleIdentifier) { bundle in
                HStack {
                    Text(bundle.bundleIdentifier ?? "none")
                    Button("OPEN") {
                        if let urll = url as? URL {
                            openInSpecificBrowser(url: urll, appId: bundle.bundleIdentifier)
                        }
                    }
                }
            }
        }
    }
    
    func openInSpecificBrowser(url: URL, appId: String? = nil) -> Bool {
        return NSWorkspace.shared.open(
            [url],
            withAppBundleIdentifier: appId,
            options: NSWorkspace.LaunchOptions.default,
            additionalEventParamDescriptor: nil,
            launchIdentifiers: nil
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            url: URL(string: "www.apple.com"),
            browsers: [Bundle]()
        )
    }
}
