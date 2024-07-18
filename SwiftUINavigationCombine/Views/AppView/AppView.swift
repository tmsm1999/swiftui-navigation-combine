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

        switch viewModel.state.tabsState {
        case .loading:
            Text("Loading")
        case .success(let tabsViewModels):
            Group {
                TabView {
                    ForEach(tabsViewModels) { tabViewModel in
                        TabPageView(viewModel: tabViewModel)
                            .tabItem {
                                Label("Menu", systemImage: "list.dash")
                            }
                    }
                }
                .sheet(isPresented: $viewModel.sheetIsPresented) {
                    if case .success(let sheetViewModel) = viewModel.state.sheetState {
                        TabPageView(viewModel: sheetViewModel)
                    }
                }
            }
        }
    }
}
