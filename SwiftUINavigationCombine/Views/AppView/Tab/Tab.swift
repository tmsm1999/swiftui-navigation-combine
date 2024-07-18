//
//  Tabs.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 17/07/2024.
//

import Foundation

enum Tab {

    case tabOne
    case tabTwo
    case tabThree

    enum NavigationAction {

        case push(NavigationService.Destination)
        case pop
        case popToRoot
        case present(NavigationService.Destination)
    }
}
