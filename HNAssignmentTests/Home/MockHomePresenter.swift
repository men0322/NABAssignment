//
//  MockHomePresenter.swift
//  HNAssignmentTests
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/25/21.
//

import Foundation
import HNService
import HNCommon
import RxCocoa
import RxSwift
@testable import HNAssignment

final class MockHomePresenter: HomeViewModelPresentable {
    
    var listener: HNHomePresentableListener?

    var invokedHomeCellViewModelsGetter = false
    var invokedHomeCellViewModelsGetterCount = 0
    var stubbedHomeCellViewModels: BehaviorRelay<[HNHomeWeatherCellViewModel]>!

    var homeCellViewModels: BehaviorRelay<[HNHomeWeatherCellViewModel]> {
        invokedHomeCellViewModelsGetter = true
        invokedHomeCellViewModelsGetterCount += 1
        return stubbedHomeCellViewModels
    }

    var invokedIsLoadingGetter = false
    var invokedIsLoadingGetterCount = 0
    var stubbedIsLoading: BehaviorRelay<Bool>!

    var isLoading: BehaviorRelay<Bool> {
        invokedIsLoadingGetter = true
        invokedIsLoadingGetterCount += 1
        return stubbedIsLoading
    }

    var invokedShowErrorMessageGetter = false
    var invokedShowErrorMessageGetterCount = 0
    var stubbedShowErrorMessage: PublishRelay<String>!

    var showErrorMessage: PublishRelay<String> {
        invokedShowErrorMessageGetter = true
        invokedShowErrorMessageGetterCount += 1
        return stubbedShowErrorMessage
    }
}
