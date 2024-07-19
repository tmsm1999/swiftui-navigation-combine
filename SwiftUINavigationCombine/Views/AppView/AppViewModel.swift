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

    var appState: AppViewModel.AppState { get set }
    
    var sheetIsPresented: Bool { get set }

    func dismissSheet() -> Void
}

final class AppViewModel: AppViewModelRepresentable {

    @Published var appState = AppViewModel.AppState()
    @Published var sheetIsPresented: Bool = false

    private var subscribers = Set<AnyCancellable>()

    private let navigationService: NavigationServiceRepresentable

    init(navigationService: NavigationServiceRepresentable) {

        self.navigationService = navigationService

        load()
        setUpBindings()
    }

    private func load() {

        let tabs = [
            AppViewModel.makeContainerViewModel(container: .tabOne, identifier: .one),
            AppViewModel.makeContainerViewModel(container: .tabTwo, identifier: .two),
            AppViewModel.makeContainerViewModel(container: .tabThree, identifier: .three)
        ]

        appState.tabsState = .success(tabs)
    }

    private func setUpBindings() {

        navigationService.showSheetAction
            .map { identifier in

                let sheetViewModel = AppViewModel.makeContainerViewModel(container: .sheet, identifier: identifier)
                return .presenting(sheetViewModel)
            }
            .assign(to: &appState.$sheetState)
    }

    func dismissSheet() {
        
        appState.sheetState = .dismissed
    }
}

extension AppViewModel {

    class AppState: ObservableObject {

        var tabsState: TabState = .initial

        @Published var sheetState: SheetState = .dismissed {
            didSet {
                switch sheetState {
                case .dismissed:
                    sheetIsPresented = false
                case .presenting:
                    sheetIsPresented = true
                }
            }
        }

        @Published var sheetIsPresented: Bool = false

        enum TabState {

            case initial
            case success([ContainerViewModel])
        }

        enum SheetState {

            case dismissed
            case presenting(ContainerViewModel)
        }
    }
}

extension AppViewModel {

    static func make() -> AppViewModel {

        .init(navigationService: ServiceLocator.shared.navigationService)
    }
}
