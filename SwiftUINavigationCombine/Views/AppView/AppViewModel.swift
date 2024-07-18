//
//  AppViewModel.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine
import SwiftUI

protocol AppViewModelRepresentable: ObservableObject {

    var state: AppViewModel.State { get }
    var sheetIsPresented: Bool { get set }
}

final class AppViewModel: AppViewModelRepresentable {

    @Published var state: AppViewModel.State
    @Published var sheetIsPresented: Bool = false

    private var subscribers = Set<AnyCancellable>()

    private let navigationService: NavigationServiceRepresentable

    init(navigationService: NavigationServiceRepresentable) {
        
        self.state = .init(tabsState: .loading, sheetState: .loading)
        self.navigationService = navigationService

        load()
        setUpBindings()
    }

    private func load() {

        let tabs = [
            makeCoordinatorRootDestination(coordinator: .tabOne, identifier: .one),
            makeCoordinatorRootDestination(coordinator: .tabTwo, identifier: .two),
            makeCoordinatorRootDestination(coordinator: .tabThree, identifier: .three)
        ]

        state.tabsState = .success(tabs)
    }

    private func setUpBindings() {

        navigationService.sheetRoot
            .sink { [weak self] identifier in

                guard let self else { return }

                let sheetNavigationAction = PassthroughSubject<Coordinator.NavigationAction, Never>()

                let sheetViewModel = makeCoordinatorRootDestination(coordinator: .sheet, identifier: identifier)

                state.sheetState = .success(sheetViewModel)
                sheetIsPresented = true
            }
            .store(in: &subscribers)
    }


    private func makeCoordinatorRootDestination(
        coordinator: Coordinator,
        identifier: NavigationService.Destination.Identifier
    ) -> TabPageViewModel {

        let navigationAction = PassthroughSubject<Coordinator.NavigationAction, Never>()

        switch identifier {
        case .one:
            let oneViewModel = OneViewModel.make(navigationAction: navigationAction)
            return TabPageViewModel.make(
                tab: coordinator,
                destination: .one(oneViewModel),
                navigationAction: navigationAction
            )
        case .two:
            let twoViewModel = TwoViewModel.make(navigationAction: navigationAction)
            return TabPageViewModel.make(
                tab: coordinator,
                destination: .two(twoViewModel),
                navigationAction: navigationAction
            )
        case .three:
            let threeViewModel = ThreeViewModel.make(navigationAction: navigationAction)
            return TabPageViewModel.make(
                tab: coordinator,
                destination: .three(threeViewModel),
                navigationAction: navigationAction
            )
        case .four:
            let fourViewModel = FourViewModel.make(navigationAction: navigationAction)
            return TabPageViewModel.make(
                tab: coordinator,
                destination: .four(fourViewModel),
                navigationAction: navigationAction
            )
        }

    }
}

extension AppViewModel {

    struct State {

        var tabsState: Tabs
        var sheetState: Sheet

        enum Tabs {
            case loading
            case success([TabPageViewModel])
        }

        enum Sheet {
            case loading
            case success(TabPageViewModel)
        }
    }
}

extension AppViewModel {

    static func make() -> AppViewModel {

        .init(navigationService: ServiceLocator.shared.navigationService)
    }
}
