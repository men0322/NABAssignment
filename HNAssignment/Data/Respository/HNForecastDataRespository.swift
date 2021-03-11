//
//  HNForecastDataRespository.swift
//  HNAssignment
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/24/21.
//

import Foundation
import UIKit
import RxSwift
import HNService
import HNCommon

class HNForecastDataRespository: HNForecastRepository {
    let movieService: HNWeatherServiceType
    
    init(movieService: HNWeatherServiceType) {
        self.movieService = movieService
    }
    
    func getForecastDaily(query: String, cnt: Int, units: String) -> Observable<[HNForecast]> {
        return movieService.getForecastDaily(query: query, cnt: cnt, units: units).map { $0?.items ?? [] }
    }
}
