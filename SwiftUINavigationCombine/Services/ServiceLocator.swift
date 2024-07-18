//
//  ServiceLocator.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation
import Combine

final class ServiceLocator {

    static let shared = ServiceLocator()

    let navigationService: NavigationServiceRepresentable

    private init(navigationService: NavigationServiceRepresentable = NavigationService()) {

        self.navigationService = navigationService
    }
}
