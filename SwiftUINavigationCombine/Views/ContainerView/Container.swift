//
//  Tabs.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation

enum Container {

    case tabOne
    case tabTwo
    case tabThree
    case sheet

    enum NavigationAction {

        case push(NavigationService.Destination)
        case pop
        case popToRoot
        case present(NavigationService.Destination.Identifier)
    }
}
