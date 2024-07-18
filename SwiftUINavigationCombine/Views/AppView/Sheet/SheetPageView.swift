//
//  SheetPageView.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 18/07/2024.
//

import SwiftUI

struct SheetPageView<ViewModel: SheetPageViewModelRepresentable>: View {

    @ObservedObject var viewModel: ViewModel

    @State private var tabPath = NavigationPath()
    @State private var state: SheetPageViewModel.State

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
        self.state = viewModel.state
    }

    var body: some View {
        switch viewModel.state {
        case .error:
            Text("Error")
        case .loading:
            Text("Loading")
        case .success:
            NavigationStack(path: $tabPath) {
                createView(destination: viewModel.destination)
                    .navigationDestination(for: NavigationService.Destination.self) { destination in
                        createView(destination: destination)
                    }
            }
            .onChange(of: viewModel.state) { _, newState in
                switch newState {
                case .success(let newPath):
                    self.tabPath = newPath
                case .loading, .error:
                    break
                }
            }
        }
    }

    @ViewBuilder
    func createView(destination: NavigationService.Destination) -> some View {

        switch destination {
        case .one(let viewModel):
            OneView(viewModel: viewModel)
        case .two(let viewModel):
            TwoView(viewModel: viewModel)
        case .three(let viewModel):
            ThreeView(viewModel: viewModel)
        case .four(let viewModel):
            FourView(viewModel: viewModel)
        }
    }
}
