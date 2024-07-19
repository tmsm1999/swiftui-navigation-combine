//
//  NavigationService.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine
import SwiftUI

protocol NavigationServiceRepresentable {

    var action: PassthroughSubject<NavigationService.TabAction, Never> { get }
    var statePublisher: Published<NavigationService.State>.Publisher { get }
    var showSheetAction: PassthroughSubject<NavigationService.Destination.Identifier, Never> { get }
}

typealias Paths = [Container: NavigationPath?]

final class NavigationService: NavigationServiceRepresentable {

    var action = PassthroughSubject<TabAction, Never>()
    var showSheetAction = PassthroughSubject<NavigationService.Destination.Identifier, Never>()
    
    // TODO: Mudar para PassthroughSubject
    @Published private var state: NavigationService.State
    var statePublisher: Published<NavigationService.State>.Publisher { $state }

    private var paths: Paths = [
        .tabOne: NavigationPath(),
        .tabTwo: NavigationPath(),
        .tabThree: NavigationPath(),
        .sheet: nil
    ]

    init() {

        state = .update(paths)

        setUpBindings()
    }

    private func setUpBindings() {
        
        action
            .map { [weak self] action in

                guard let self else { return .error }

                switch action {
                case .push(let destination, let tab):
                    paths[tab]??.append(destination)
                case .pop(let tab):
                    guard let numberOfElements = paths[tab]??.count else { return .error }
                    if numberOfElements > 0 { paths[tab]??.removeLast() }
                case .popToRoot(let tab):
                    paths[tab] = NavigationPath()
                case .presentSheet(let destinationID):
                    paths[.sheet] = NavigationPath()
                    showSheetAction.send(destinationID)
                }

                return .update(paths)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
}

extension NavigationService {

    enum State {

        case update(Paths)
        case error
    }
}

extension NavigationService {

    enum TabAction {

        case push(Destination, Container)
        case pop(Container)
        case popToRoot(Container)
        case presentSheet(Destination.Identifier)
    }
}

extension NavigationService {

    enum Destination: Hashable {

        case one(OneViewModel)
        case two(TwoViewModel)
        case three(ThreeViewModel)
        case four(FourViewModel)

        enum Identifier {

            case one
            case two
            case three
            case four
        }

        var id: Identifier {
            switch self {
            case .one: return .one
            case .two: return .two
            case .three: return .three
            case .four: return .four
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
