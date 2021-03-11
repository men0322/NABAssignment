//
//  HNGetMoviesUseCase.swift
//  HNAssignment
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/24/21.
//

import Foundation
import HNService
import RxSwift

class HNGetForecastDailyUseCase: HNBaseUseCase {
    typealias Output = [HNForecast]
    
    typealias Input = Param
    
    let repository: HNForecastRepository
    
    init(repository: HNForecastRepository) {
        self.repository = repository
    }
    
    func run(input: Param) -> Observable<Output> {
        return repository.getForecastDaily(query: input.query, cnt: input.cnt, units: input.units)
    }
    
    struct Param {
        var query: String
        var cnt: Int
        var units: String
    }
}
