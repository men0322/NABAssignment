//
//  HNHomeViewModel.swift
//  HNAssignment
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/24/21.
//

import UIKit
import HNCommon
import HNService
import RxSwift
import RxCocoa
import Action

protocol HomeViewModelPresentable: class {
    var listener: HNHomePresentableListener? { get set }
    var homeCellViewModels: BehaviorRelay<[HNHomeWeatherCellViewModel]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var showErrorMessage: PublishRelay<String> { get }
}

protocol HomeViewModelRouting: class {
    func goToWeatherDetail()
}

class HNHomeViewModel: ViewModelType, HNHomePresentableListener {
    // Listener
    let refreshTrigger = PublishRelay<Void>()
    let searchTrigger = PublishRelay<String>()
    let didSelectForecastTrigger = PublishRelay<HNHomeWeatherCellViewModel?>()
    
    // Variable
    let disposeBag = DisposeBag()
    
    weak var presenter: HomeViewModelPresentable?
    weak var router: HomeViewModelRouting?
    
    public lazy var getForecastDailyAction = buildGetForecastDailyAction()
    
    let getMoviesUseCase: HNGetForecastDailyUseCase
    
    // Constants
    struct Constants {
        static let units = "metric"
        static let cnt = 7
        static let searchMinimum = 3
        static let timeCachingSearch = DispatchTimeInterval.milliseconds(500)
    }
    
    init(getMoviesUseCase: HNGetForecastDailyUseCase) {
        self.getMoviesUseCase = getMoviesUseCase
    }
    
    func didBecomeActive() {
        presenter?.listener = self
        configurePresenter()
        configureListener()
    }

    func configurePresenter() {
        guard let presenter = presenter else { return }
        
        getForecastDailyAction
            .underlyingError
            .map { R.string.localizable.homeErrorMessage(String(format: "%f", ($0 as NSError).code)) }
            .bind(to: presenter.showErrorMessage)
            .disposed(by: disposeBag)
        
        getForecastDailyAction
            .elements
            .map { $0.map { HNHomeWeatherCellViewModel(forecast: $0) } }
            .bind(to: presenter.homeCellViewModels)
            .disposed(by: disposeBag)
        
        getForecastDailyAction
            .executing
            .bind(to: presenter.isLoading)
            .disposed(by: disposeBag)
        
        searchTrigger
            .debounce(Constants.timeCachingSearch, scheduler: MainScheduler.instance)
            .filter { [weak self] searchValue -> Bool in
                if searchValue.count >= Constants.searchMinimum {
                    return true
                }
                self?.presenter?.homeCellViewModels.accept([])
                return false
            }
            .map { ($0, Constants.cnt, Constants.units) }
            .bind(to: getForecastDailyAction.inputs)
            .disposed(by: disposeBag)
    }
    
    func configureListener() {
        refreshTrigger
            .subscribeNext { [weak self] in
                self?.presenter?.homeCellViewModels.accept([])
            }
            .disposed(by: disposeBag)
        
        didSelectForecastTrigger
            .subscribeNext { [weak self] movie in
                // Handle logic and send param to viewcontroler
                self?.router?.goToWeatherDetail()
            }
            .disposed(by: disposeBag)
    }
}

extension HNHomeViewModel {
    func buildGetForecastDailyAction() -> Action<(query: String,
                                                  cnt: Int,
                                                  units: String),
                                                 [HNForecast]> {
        return Action<(query: String,
                       cnt: Int,
                       units: String),
                      [HNForecast]> { [unowned self] params in
            self.getMoviesUseCase
                .execute(
                    input: HNGetForecastDailyUseCase.Param(query: params.query,
                                                           cnt: params.cnt,
                                                           units: params.units)
                )
        }
    }
}
