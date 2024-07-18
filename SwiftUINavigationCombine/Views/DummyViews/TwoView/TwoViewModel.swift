//
//  TwoViewModel.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine

protocol TwoViewModelRepresentable {

    var action: PassthroughSubject<TwoViewModel.Action, Never> { get }
}

final class TwoViewModel: TwoViewModelRepresentable {

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
                case .pushTree:
                    let threeViewModel = ThreeViewModel.make(navigationAction: navigationAction)
                    navigationAction.send(.push(.three(threeViewModel)))
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

extension TwoViewModel {

    enum Action {

        case pop
        case pushTree
        case pushFour
    }
}

extension TwoViewModel {

    static func make(navigationAction: PassthroughSubject<Container.NavigationAction, Never>) -> TwoViewModel {

        .init(navigationAction: navigationAction, navigationService: ServiceLocator.shared.navigationService)
    }
}
