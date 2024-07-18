//
//  FourViewMode.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine

protocol FourViewModelRepresentable {

    var action: PassthroughSubject<FourViewModel.Action, Never> { get }
}

final class FourViewModel: FourViewModelRepresentable {

    var action = PassthroughSubject<Action, Never>()
    private var subscriptions = Set<AnyCancellable>()

    private let navigationService: NavigationServiceRepresentable
    private var navigationAction: PassthroughSubject<Container.NavigationAction, Never>

    init(
        navigationAction: PassthroughSubject<Container.NavigationAction, Never>,
        navigationService: NavigationServiceRepresentable
    ) {
        
        self.navigationAction = navigationAction
        self.navigationService = navigationService

        setUpBindings()
    }

    private func setUpBindings() {
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }

                switch action {
                case .popToRoot:
                    navigationAction.send(.popToRoot)
                }
            }
            .store(in: &subscriptions)
    }
}

extension FourViewModel {

    enum Action {

        case popToRoot
    }
}

extension FourViewModel {

    static func make(navigationAction: PassthroughSubject<Container.NavigationAction, Never>) -> FourViewModel {

        .init(navigationAction: navigationAction, navigationService: ServiceLocator.shared.navigationService)
    }
}

