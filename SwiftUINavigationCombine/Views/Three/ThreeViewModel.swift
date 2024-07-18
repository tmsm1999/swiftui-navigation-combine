//
//  ThreeViewModel.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine

protocol ThreeViewModelRepresentable {

    var action: PassthroughSubject<ThreeViewModel.Action, Never> { get }
}

final class ThreeViewModel: ThreeViewModelRepresentable {

    var action = PassthroughSubject<Action, Never>()
    private var subscriptions = Set<AnyCancellable>()

    private let navigationService: NavigationServiceRepresentable
    private var navigationAction: PassthroughSubject<Tab.NavigationAction, Never>

    init(
        navigationAction: PassthroughSubject<Tab.NavigationAction, Never>,
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
                case .pushFour:
                    let fourViewModel = FourViewModel.make(navigationAction: navigationAction)
                    navigationAction.send(.push(.four(fourViewModel)))
                case .pop:
                    navigationAction.send(.pop)
                }
            }
            .store(in: &subscriptions)
    }
}

extension ThreeViewModel {

    enum Action {
        
        case pop
        case pushFour
    }
}

extension ThreeViewModel {

    static func make(navigationAction: PassthroughSubject<Tab.NavigationAction, Never>) -> ThreeViewModel {

        .init(navigationAction: navigationAction, navigationService: ServiceLocator.shared.navigationService)
    }
}
