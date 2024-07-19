//
//  AppView.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 18/07/2024.
//

import SwiftUI

struct AppView<ViewModel: AppViewModelRepresentable>: View {

    @ObservedObject var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        switch viewModel.appState.tabsState {
        case .initial:
            Text("Initial State")
        case .success(let tabsViewModels):
            Group {
                TabView {
                    ForEach(tabsViewModels) { tabViewModel in
                        ContainerView(viewModel: tabViewModel)
                            .tabItem {
                                Label("Menu", systemImage: "list.dash")
                            }
                    }
                }
                .sheet(isPresented: $viewModel.appState.sheetIsPresented) {
                    if case .presenting(let sheetViewModel) = viewModel.appState.sheetState {
                        ContainerView(viewModel: sheetViewModel)
                    }
                }
            }
        }
    }
}
