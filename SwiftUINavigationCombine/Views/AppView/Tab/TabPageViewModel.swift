//
//  TabOneViewMode.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine
import SwiftUI

protocol TabPageViewModelRepresentable: ObservableObject, Identifiable {

    var navigationAction: PassthroughSubject<Coordinator.NavigationAction, Never> { get }
    var state: TabPageViewModel.State { get }
    var destination: NavigationService.Destination { get }
    var sheetIsPresented: Bool { get }
}

final class TabPageViewModel: TabPageViewModelRepresentable {

    let navigationAction: PassthroughSubject<Coordinator.NavigationAction, Never>
    private var subscriptions = Set<AnyCancellable>()
    
    private let tab: Coordinator
    private let navigationService: NavigationServiceRepresentable

    let destination: NavigationService.Destination

    @Published var state: TabPageViewModel.State = .loading
    @Published var sheetIsPresented = false

    init(
        tab: Coordinator,
        tabNavigationAction: PassthroughSubject<Coordinator.NavigationAction, Never>,
        destination: NavigationService.Destination,
        navigationService: NavigationServiceRepresentable
    ) {

        self.tab = tab
        self.navigationAction = tabNavigationAction
        self.destination = destination
        self.navigationService = navigationService

        setUpBindings()
    }

    private func setUpBindings() {

        navigationAction
            .sink { [weak self] navigationAction in

                guard let self else { return }

                switch navigationAction {
                case .push(let destination):
                    navigationService.action.send(.push(destination, tab))
                case .pop:
                    navigationService.action.send(.pop(tab))
                case .popToRoot:
                    navigationService.action.send(.popToRoot(tab))
                case .present(let destination):
                    navigationService.action.send(.presentSheet(destination))
                }
            }
            .store(in: &subscriptions)

        navigationService.statePublisher
            .compactMap { [weak self] state in

                guard let self else { return .error }

                switch state {
                case .update(let paths):
                    guard
                        let lookupUnwrap = paths[tab],
                        let navigationPath = lookupUnwrap
                    else { return .error }

                    return .success(navigationPath)
                case .error:
                    return .error
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)

    }
}

extension TabPageViewModel {

    enum State: Equatable {

        case success(NavigationPath)
        case loading
        case error
    }
}

extension TabPageViewModel {

    static func make(
        tab: Coordinator,
        destination: NavigationService.Destination,
        navigationAction: PassthroughSubject<Coordinator.NavigationAction, Never>
    ) -> TabPageViewModel {

        .init(
            tab: tab,
            tabNavigationAction: navigationAction,
            destination: destination,
            navigationService: ServiceLocator.shared.navigationService
        )
    }
}
