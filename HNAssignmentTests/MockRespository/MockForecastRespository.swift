//
//  MockRespository.swift
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

final class MockForecastRespository: HNForecastRepository {
    
    var invokedGetForecastDaily = false
    var invokedGetForecastDailyCount = 0
    var invokedGetForecastDailyParameters: (query: String, cnt: Int, units: String)?
    var invokedGetForecastDailyParametersList = [(query: String, cnt: Int, units: String)]()
    var stubbedGetForecastDailyResult: Observable<[HNForecast]>!

    func getForecastDaily(query: String, cnt: Int, units: String) -> Observable<[HNForecast]> {
        invokedGetForecastDaily = true
        invokedGetForecastDailyCount += 1
        invokedGetForecastDailyParameters = (query, cnt, units)
        invokedGetForecastDailyParametersList.append((query, cnt, units))
        return stubbedGetForecastDailyResult
    }
}

