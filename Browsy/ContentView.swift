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
        
        let template = "URL: %@"
        
        VStack {
            Text(String(format: template, url.absoluteString))
                .padding()
            List(browsers, id: \.bundleIdentifier) { bundle in
                HStack {
                    Image("*.icns", bundle: bundle)
                    Text(bundle.bundleIdentifier ?? "none")
                    Button("OPEN") {
                        BrowserHelper().openInSpecificBrowser(
                            url: url,
                            bundleUrl: bundle.bundleURL
                        )
                        NSApplication.shared.keyWindow?.close()
                    }
                }
            }
        }
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
