//
//  Tabs.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation

typealias Identifier = NavigationService.Destination.Identifier

enum Container {

    case tabOne
    case tabTwo
    case tabThree
    case sheet

    enum NavigationAction {

        case push(Identifier)
        case pop
        case popToRoot
        case present(Identifier)
    }
}
