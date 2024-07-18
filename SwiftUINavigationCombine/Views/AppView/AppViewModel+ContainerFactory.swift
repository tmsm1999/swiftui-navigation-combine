//
//  AppViewModel+ContainerFactory.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 18/07/2024.
//

import Foundation
import Combine

extension AppViewModel {

    static func makeContainerViewModel(
        container: Container,
        identifier: Identifier
    ) -> ContainerViewModel {

        let navigationAction = PassthroughSubject<Container.NavigationAction, Never>()

        switch identifier {
        case .one:
            let oneViewModel = OneViewModel.make(navigationAction: navigationAction)
            return ContainerViewModel.make(
                container: container,
                destination: .one(oneViewModel),
                navigationAction: navigationAction
            )
        case .two:
            let twoViewModel = TwoViewModel.make(navigationAction: navigationAction)
            return ContainerViewModel.make(
                container: container,
                destination: .two(twoViewModel),
                navigationAction: navigationAction
            )
        case .three:
            let threeViewModel = ThreeViewModel.make(navigationAction: navigationAction)
            return ContainerViewModel.make(
                container: container,
                destination: .three(threeViewModel),
                navigationAction: navigationAction
            )
        case .four:
            let fourViewModel = FourViewModel.make(navigationAction: navigationAction)
            return ContainerViewModel.make(
                container: container,
                destination: .four(fourViewModel),
                navigationAction: navigationAction
            )
        }
    }
}
