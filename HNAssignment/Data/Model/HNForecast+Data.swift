//
//  HNForecast+Data.swift
//  HNAssignment
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/24/21.
//

import Foundation
import HNService
import HNCommon

extension HNForecast {
    var descriptionFormated: String {
        return weather?.first?.description ?? ""
    }
}
