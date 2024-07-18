//
//  ContentView.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import SwiftUI

struct ContentView: View {
    
    let appViewModel = AppViewModel(navigationService: ServiceLocator.shared.navigationService)

    var body: some View {
        AppView(viewModel: appViewModel)
    }
}
