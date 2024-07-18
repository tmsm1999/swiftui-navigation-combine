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
    private var subscribers = Set<AnyCancellable>()

    init(navigationService: NavigationServiceRepresentable) {
        
        self.state = .init(tabsState: .loading, sheetState: .dismissed)
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

        state.tabsState = .success(tabs)
    }

    private func setUpBindings() {

        navigationService.presentSheetAction
            .sink { [weak self] destination in

                guard let self else { return }

                guard let destination else {
                    state.sheetState = .dismissed
                    return
                }
                
                let navigationAction = PassthroughSubject<Sheet.NavigationAction, Never>()
                let sheetViewModel = SheetPageViewModel(
                    navigationAction: navigationAction,
                    navigationService: navigationService,
                    destination: destination
                )
                
                state.sheetState = .presented(sheetViewModel)
            }
            .store(in: &subscribers)
    }
}

extension AppViewModel {

    struct State {

        var tabsState: TabsState
        var sheetState: SheetState

        enum TabsState{

            case loading
            case success([TabPageViewModel])
        }

        enum SheetState {

            case dismissed
            case presented(SheetPageViewModel)
        }
    }
}

extension AppViewModel {

    static func make() -> AppViewModel {

        .init(navigationService: ServiceLocator.shared.navigationService)
    }
}
