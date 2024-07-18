//
//  AppView.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 18/07/2024.
//

import SwiftUI

struct AppView<ViewModel: AppViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        switch viewModel.state {
        case .loading:
            Text("Loading")
        case .success(let tabsViewModels):
            TabView {
                ForEach(tabsViewModels) { tabViewModel in
                    TabPageView(viewModel: tabViewModel)
                        .tabItem {
                            Label("Menu", systemImage: "list.dash")
                        }
                }
            }
        }
    }
}
