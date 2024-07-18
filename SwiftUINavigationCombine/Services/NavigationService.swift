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

    var tabAction: PassthroughSubject<NavigationService.TabAction, Never> { get }
    var sheetAction: PassthroughSubject<NavigationService.SheetAction, Never> { get }
    var statePublisher: Published<NavigationService.State>.Publisher { get }
    var presentSheetAction: PassthroughSubject<NavigationService.Destination?, Never> { get }
}

typealias Paths = [Tab: NavigationPath]

final class NavigationService: NavigationServiceRepresentable {

    var tabAction = PassthroughSubject<TabAction, Never>()
    var sheetAction = PassthroughSubject<SheetAction, Never>()

    @Published private var state: NavigationService.State
    var statePublisher: Published<NavigationService.State>.Publisher { $state }

    private var paths: Paths = [
        .tabOne: NavigationPath(),
        .tabTwo: NavigationPath(),
        .tabThree: NavigationPath()
    ]

    private var sheetPath = NavigationPath()
    var presentSheetAction = PassthroughSubject<NavigationService.Destination?, Never>()

    init() {

        state = .update(tabsPaths: paths, sheetPath: sheetPath)

        setUpBindings()
    }

    private func setUpBindings() {
        
        tabAction
            .map { [weak self] action in

                guard let self else { return .error }

                switch action {
                case .push(let destination, let tab):
                    paths[tab]?.append(destination)
                case .pop(let tab):
                    guard let path = paths[tab] else { return .error }
                    if !path.isEmpty { paths[tab]?.removeLast() }
                case .popToRoot(let tab):
                    paths[tab] = NavigationPath()
                }

                return .update(tabsPaths: paths, sheetPath: sheetPath)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)

        sheetAction
            .map { [weak self] action in

                guard let self else { return .error }
                switch action {
                case .push(let destination):
                    sheetPath.append(destination)
                case .pop:
                    if !sheetPath.isEmpty { sheetPath.removeLast() }
                case .popToRoot:
                    sheetPath = NavigationPath()
                case .present(let destination):
                    presentSheetAction.send(destination)
                case .dismiss:
                    presentSheetAction.send(nil)
                }

                return .update(tabsPaths: paths, sheetPath: sheetPath)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
}

extension NavigationService {

    enum State {

        case update(tabsPaths: Paths, sheetPath: NavigationPath)
        case error
    }
}

extension NavigationService {

    enum TabAction {

        case push(Destination, Tab)
        case pop(Tab)
        case popToRoot(Tab)
    }

    enum SheetAction {

        case push(Destination)
        case pop
        case popToRoot
        case present(Destination)
        case dismiss
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
