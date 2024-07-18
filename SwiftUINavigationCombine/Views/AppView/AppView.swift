//
//  AppView.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 18/07/2024.
//

import SwiftUI

struct AppView<ViewModel: AppViewModelRepresentable>: View {

    private var viewModel: ViewModel

    private var sheetIsPresented: Bool {
        if case .dismissed = viewModel.state.sheetState {
            return false
        }
        return true
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        switch viewModel.state.tabsState {
        case .loading:
            Text("Loading")
        case .success(let tabsViewModels):
            TabView {
                ForEach(tabsViewModels) { tabViewModel in
                    TabPageView(viewModel: tabViewModel)
                        .tabItem {
                            Label("Menu", systemImage: "list.dash")
                        }
                        .sheet(isPresented: Binding(get: { self.sheetIsPresented }, set: { _ in })) {

                            if case .presented(let viewModel) = viewModel.state.sheetState {
                                SheetPageView(viewModel: viewModel)
                            }
                        }
                }
            }
        }
    }
}
