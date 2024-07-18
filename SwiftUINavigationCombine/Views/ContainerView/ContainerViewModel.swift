//
//  TabOneViewMode.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine
import SwiftUI

protocol ContainerViewModelRepresentable: ObservableObject, Identifiable {

    var navigationAction: PassthroughSubject<Container.NavigationAction, Never> { get }
    var state: ContainerViewModel.State { get }
    var destination: NavigationService.Destination { get }
}

final class ContainerViewModel: ContainerViewModelRepresentable {

    let navigationAction: PassthroughSubject<Container.NavigationAction, Never>
    private var subscriptions = Set<AnyCancellable>()
    
    private let container: Container
    private let navigationService: NavigationServiceRepresentable

    let destination: NavigationService.Destination

    @Published var state: ContainerViewModel.State = .loading

    init(
        container: Container,
        navigationAction: PassthroughSubject<Container.NavigationAction, Never>,
        destination: NavigationService.Destination,
        navigationService: NavigationServiceRepresentable
    ) {

        self.container = container
        self.navigationAction = navigationAction
        self.destination = destination
        self.navigationService = navigationService

        setUpBindings()
    }

    private func setUpBindings() {

        navigationAction
            .sink { [weak self] action in

                guard let self else { return }

                switch action {
                case .push(let destinationID):
                    let destination = Container.makeChildView(
                        viewIdentifier: destinationID,
                        navigationAction: navigationAction
                    )
                    navigationService.action.send(.push(destination, container))
                case .pop:
                    navigationService.action.send(.pop(container))
                case .popToRoot:
                    navigationService.action.send(.popToRoot(container))
                case .present(let destinationID):
                    navigationService.action.send(.presentSheet(destinationID))
                }
            }
            .store(in: &subscriptions)

        navigationService.statePublisher
            .compactMap { [weak self] state in

                guard let self else { return .error }

                switch state {
                case .update(let paths):
                    guard
                        let lookupUnwrap = paths[container],
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

extension ContainerViewModel {

    enum State: Equatable {

        case success(NavigationPath)
        case loading
        case error
    }
}

extension ContainerViewModel {

    static func make(
        container: Container,
        destination: NavigationService.Destination,
        navigationAction: PassthroughSubject<Container.NavigationAction, Never>
    ) -> ContainerViewModel {

        .init(
            container: container,
            navigationAction: navigationAction,
            destination: destination,
            navigationService: ServiceLocator.shared.navigationService
        )
    }
}
