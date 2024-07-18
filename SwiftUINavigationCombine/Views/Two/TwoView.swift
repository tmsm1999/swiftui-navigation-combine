//
//  TwoView.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import SwiftUI

struct TwoView<ViewModel: TwoViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        VStack(spacing: 20) {

            Button("Push Three") {
                viewModel.action.send(.pushTree)
            }

            Button("Push Four") {
                viewModel.action.send(.pushFour)
            }

            Button("Pop") {
                viewModel.action.send(.pop)
            }
        }
        .navigationTitle("Two")
    }
}
