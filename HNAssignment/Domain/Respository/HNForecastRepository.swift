//
//  HNForecastRepository.swift
//  HNAssignment
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/24/21.
//

import RxSwift
import HNService

protocol HNForecastRepository {
    func getForecastDaily(query: String, cnt: Int, units: String) -> Observable<[HNForecast]>
}
