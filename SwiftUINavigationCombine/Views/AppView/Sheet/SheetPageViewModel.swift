//
//  SheetPageViewModel.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 18/07/2024.
//

import Foundation
import Combine
import SwiftUI

protocol SheetPageViewModelRepresentable: ObservableObject {

    var navigationAction: PassthroughSubject<Sheet.NavigationAction, Never> { get }
    var state: SheetPageViewModel.State { get }
    var destination: NavigationService.Destination { get }
}

final class SheetPageViewModel: SheetPageViewModelRepresentable {

    let navigationAction: PassthroughSubject<Sheet.NavigationAction, Never>
    private var subscriptions = Set<AnyCancellable>()

    private let navigationService: NavigationServiceRepresentable
    let destination: NavigationService.Destination
    
    @Published var state: SheetPageViewModel.State = .loading

    init(
        navigationAction: PassthroughSubject<Sheet.NavigationAction, Never>,
        navigationService: NavigationServiceRepresentable,
        destination: NavigationService.Destination
    ) {

        self.navigationAction = navigationAction
        self.navigationService = navigationService
        self.destination = destination
    }

    private func setUpBindings() {

        
    }
}

extension SheetPageViewModel {

    enum State: Equatable {

        case success(NavigationPath)
        case loading
        case error
    }
}

extension SheetPageViewModel {

    static func make(
        navigationAction: PassthroughSubject<Sheet.NavigationAction, Never>,
        destination: NavigationService.Destination
    ) -> SheetPageViewModel {

        .init(
            navigationAction: navigationAction,
            navigationService: ServiceLocator.shared.navigationService,
            destination: destination
        )
    }
}
