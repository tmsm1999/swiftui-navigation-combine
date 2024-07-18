//
//  FourView.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import SwiftUI

struct FourView<ViewModel: FourViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {

            Button("Pop to Root") {
                viewModel.action.send(.popToRoot)
            }
        }
        .navigationTitle("Four")
    }
}
