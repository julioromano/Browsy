//
//  MenuView.swift
//  Browsy
//
//  Created by julionb on 01/06/24.
//

import SwiftUI

struct MenuView: View {
    let quitAction: () -> Void
    let checkForUpdates: () -> Void
    
    var body: some View {
        Text("Browsy v0.1")
        Button(action: checkForUpdates, label: { Text("Check for updates...") })
        Divider()
        Button(action: quitAction, label: { Text("Quit") })
            .keyboardShortcut("q", modifiers: .command)
    }
}

#Preview {
    MenuView(
        quitAction: {},
        checkForUpdates: {}
    )
}
