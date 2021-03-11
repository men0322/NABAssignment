//
//  HNBaseUseCases.swift
//  HNAssignment
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/24/21.
//

import Foundation
import RxSwift

protocol HNBaseUseCase {
    associatedtype Output
    associatedtype Input
    func run(input: Input) -> Observable<Output>
}

extension HNBaseUseCase {
    func execute(input: Input) -> Observable<Output> {
        return self.run(input: input)
            .observeOn(MainScheduler.instance)
    }
}

struct ParamNone {
    
}
