//
//  ChooserScreenBindingView.swift
//  Browsy
//
//  Created by julionb on 30/05/24.
//

import SwiftUI

struct ChooserScreenBindingView: View {
    @ObservedObject var presenter: ChooserScreenPresenter
    
    var body: some View {
        ChooserScreenView(
            state: presenter.state,
            onBrowserClicked: presenter.onBrowserClicked
        )
    }
}
