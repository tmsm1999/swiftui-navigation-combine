//
//  ViewOneViewMode.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine

protocol OneViewModelRepresentable {

    var action: PassthroughSubject<OneViewModel.Action, Never> { get }
}

final class OneViewModel: OneViewModelRepresentable {

    var action = PassthroughSubject<Action, Never>()
    private var subscriptions = Set<AnyCancellable>()

    private let navigationService: NavigationServiceRepresentable
    private var navigationAction: PassthroughSubject<Container.NavigationAction, Never>

    init(
        navigationService: NavigationServiceRepresentable,
        navigationAction: PassthroughSubject<Container.NavigationAction, Never>
    ) {

        self.navigationService = navigationService
        self.navigationAction = navigationAction

        setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }

                switch action {
                case .pushTwo:
                    let twoViewModel = TwoViewModel.make(navigationAction: navigationAction)
                    navigationAction.send(.push(.two(twoViewModel)))
                case .pushThree:
                    let threeViewModel = ThreeViewModel.make(navigationAction: navigationAction)
                    navigationAction.send(.push(.three(threeViewModel)))
                case .presentOne:
                    navigationAction.send(.present(.one))
                }
            }
            .store(in: &subscriptions)
    }
}

extension OneViewModel {

    enum Action {

        case pushTwo
        case pushThree
        case presentOne
    }
}

extension OneViewModel {

    static func make(navigationAction: PassthroughSubject<Container.NavigationAction, Never>) -> OneViewModel {

        .init(navigationService: ServiceLocator.shared.navigationService, navigationAction: navigationAction)
    }
}
