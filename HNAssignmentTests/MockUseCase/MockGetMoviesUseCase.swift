//
//  MockGetMoviesUseCase.swift
//  HNAssignmentTests
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/25/21.
//

import Foundation
import HNService
import RxCocoa
import RxSwift
import HNCommon
@testable import HNAssignment

final class MockGetMoviesUseCase: HNBaseUseCase {
    typealias Output = [HNForecast]
    typealias Input = Param
    
    var invokedRun = false
    var invokedRunCount = 0
    var invokedRunParameters: (input: Input, Void)?
    var invokedRunParametersList = [(input: Input, Void)]()
    var stubbedRunResult: Observable<Output>!

    func run(input: Input) -> Observable<Output> {
        invokedRun = true
        invokedRunCount += 1
        invokedRunParameters = (input, ())
        invokedRunParametersList.append((input, ()))
        return stubbedRunResult
    }
    
    struct Param {
        var query: String
        var cnt: Int
        var units: String
    }
}
