//
//  Container+ViewFactory.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 18/07/2024.
//

import Foundation
import Combine

extension Container {

    static func makeChildView(
        viewIdentifier: Identifier,
        navigationAction: PassthroughSubject<Container.NavigationAction, Never>
    ) -> NavigationService.Destination {

        switch viewIdentifier {
        case .one:
            let viewModel = OneViewModel.make(navigationAction: navigationAction)
            return .one(viewModel)
        case .two:
            let viewModel = TwoViewModel.make(navigationAction: navigationAction)
            return .two(viewModel)
        case .three:
            let viewModel = ThreeViewModel.make(navigationAction: navigationAction)
            return .three(viewModel)
        case .four:
            let viewModel = FourViewModel.make(navigationAction: navigationAction)
            return .four(viewModel)
        }
    }
}
