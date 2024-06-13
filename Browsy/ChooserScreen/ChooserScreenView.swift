//
//  ChooserScreenView.swift
//  Browsy
//
//  Created by julionb on 31/05/24.
//

import SwiftUI

struct ChooserScreenView: View {
    let state: ChooserScreenState
    let onBrowserClicked: (URL) -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            Text(state.url ?? "")
            List(state.browsers, id: \.self) { browser in
                HStack {
                    Image(nsImage: browser.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    Text(browser.name)
                        .font(.headline)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    onBrowserClicked(browser.appUrl)
                }
                .listRowBackground(Color(.background))
            }
        }.listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(.background))
            .cornerRadius(10)
            .frame(minWidth:200, minHeight: 200)
            .fixedSize()
    }
}

#Preview {
    ChooserScreenView(
        state: ChooserScreenState(
            url: "www.apple.com",
            browsers: aBrowserList(number: 6)
        ),
        onBrowserClicked: { _ in}
    )
}
