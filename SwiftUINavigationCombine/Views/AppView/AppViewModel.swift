//
//  AppViewModel.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine
import SwiftUI

protocol AppViewModelRepresentable {

    var state: AppViewModel.State { get }
}

final class AppViewModel: AppViewModelRepresentable {

    @Published var state: AppViewModel.State

    private let navigationService: NavigationServiceRepresentable

    init(navigationService: NavigationServiceRepresentable) {
        
        self.state = .loading
        self.navigationService = navigationService

        load()
        setUpBindings()
    }

    private func load() {

        let tabOneNavigationAction = PassthroughSubject<Tab.NavigationAction, Never>()
        let oneViewModel = OneViewModel.make(navigationAction: tabOneNavigationAction)
        let tabOneViewModel = TabPageViewModel.make(
            tab: .tabOne,
            destination: .one(oneViewModel),
            navigationAction: tabOneNavigationAction
        )
        
        let tabTwoNavigationAction = PassthroughSubject<Tab.NavigationAction, Never>()
        let twoViewModel = TwoViewModel.make(navigationAction: tabTwoNavigationAction)
        let tabTwoViewModel = TabPageViewModel.make(
            tab: .tabTwo,
            destination: .two(twoViewModel),
            navigationAction: tabTwoNavigationAction
        )

        let tabThreeNavigationAction = PassthroughSubject<Tab.NavigationAction, Never>()
        let threeViewModel = ThreeViewModel.make(navigationAction: tabThreeNavigationAction)
        let tabThreeViewModel = TabPageViewModel.make(
            tab: .tabThree,
            destination: .three(threeViewModel),
            navigationAction: tabThreeNavigationAction
        )

        let tabs = [
            tabOneViewModel,
            tabTwoViewModel,
            tabThreeViewModel
        ]

        state = .success(tabs)
    }

    private func setUpBindings() {

        

        
    }
}

extension AppViewModel {

    enum State {

        case loading
        case success([TabPageViewModel])
    }
}

extension AppViewModel {

    static func make() -> AppViewModel {

        .init(navigationService: ServiceLocator.shared.navigationService)
    }
}
