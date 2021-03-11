//
//  MockHomeRouter.swift
//  HNAssignmentTests
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/25/21.
//

import Foundation
import HNService
@testable import HNAssignment

final class MockHomeRouter: HomeViewModelRouting {
    
    var invokedGoToWeatherDetail = false
    var invokedGoToWeatherDetailCount = 0

    func goToWeatherDetail() {
        invokedGoToWeatherDetail = true
        invokedGoToWeatherDetailCount += 1
    }
}
