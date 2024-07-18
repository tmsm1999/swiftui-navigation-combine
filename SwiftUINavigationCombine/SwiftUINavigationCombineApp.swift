//
//  SwiftUINavigationCombineApp.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import SwiftUI

@main
struct SwiftUINavigationCombineApp: App {

    let appViewModel = AppViewModel(navigationService: ServiceLocator.shared.navigationService)
    
    var body: some Scene {
        WindowGroup {
            AppView(viewModel: appViewModel)
        }
    }
}
