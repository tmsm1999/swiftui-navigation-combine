//
//  OneView.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import SwiftUI

struct OneView<ViewModel: OneViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        VStack(spacing: 20) {

            Button("Push Two") {
                viewModel.action.send(.pushTwo)
            }

            Button("Push Three") {
                viewModel.action.send(.pushThree)
            }
        }
        .navigationTitle("One")
    }
}
