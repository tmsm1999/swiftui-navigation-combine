//
//  SheetPageViewModel.swift
//  SwiftUINavigationCombine
//
//  Created by Tomas Mamede on 18/07/2024.
//

import Foundation
import Combine
import SwiftUI

protocol SheetPageViewModelRepresentable {


}

final class SheetPageViewModel: SheetPageViewModelRepresentable {


}

extension SheetPageViewModel {

    enum State {

        case success(NavigationPath)
        case loading
        case error
    }
}
