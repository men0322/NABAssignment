//
//  HomeViewModelSpec.swift
//  HNAssignmentTests
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/25/21.
//

import Foundation
import HNService
import HNCommon
import RxCocoa
import ObjectMapper
import RxSwift
import Quick
import Nimble
@testable import HNAssignment

final class HomeViewModelSpec: QuickSpec {
    override func spec() {
        var sut: HNHomeViewModel!
        var mockRepository: MockForecastRespository!
        var mockPresenter: MockHomePresenter!
        var mockRouter: MockHomeRouter!
        let showErrorMessageTrigger = PublishRelay<String>()
        var mockForecastService: MockForecastService!
        
        let forecastJson = """
                {
                  "dt": 1615352400,
                  "sunrise": 1615331014,
                  "sunset": 1615374240,
                  "temp": {
                    "day": 36.3,
                    "min": 24.91,
                    "max": 37.38,
                    "night": 27.3,
                    "eve": 30.85,
                    "morn": 25.25
                  },
                  "feels_like": {
                    "day": 36.8,
                    "night": 27.63,
                    "eve": 29.07,
                    "morn": 26.77
                  },
                  "pressure": 1012,
                  "humidity": 29,
                  "weather": [
                    {
                      "id": 804,
                      "main": "Clouds",
                      "description": "overcast clouds",
                      "icon": "04d"
                    }
                  ],
                  "speed": 1.79,
                  "deg": 22,
                  "clouds": 92,
                  "pop": 0.01
                }
            """
        
        let forecastDailyJson = """
            {
              "city": {
                "id": 1580578,
                "name": "Ho Chi Minh City",
                "coord": {
                  "lon": 106.6667,
                  "lat": 10.8333
                },
                "country": "VN",
                "population": 0,
                "timezone": 25200
              },
              "cod": "200",
              "message": 0.0643443,
              "cnt": 7,
              "list": [
                {
                  "dt": 1615352400,
                  "sunrise": 1615331014,
                  "sunset": 1615374240,
                  "temp": {
                    "day": 36.3,
                    "min": 24.91,
                    "max": 37.38,
                    "night": 27.3,
                    "eve": 30.85,
                    "morn": 25.25
                  },
                  "feels_like": {
                    "day": 36.8,
                    "night": 27.63,
                    "eve": 29.07,
                    "morn": 26.77
                  },
                  "pressure": 1012,
                  "humidity": 29,
                  "weather": [
                    {
                      "id": 804,
                      "main": "Clouds",
                      "description": "overcast clouds",
                      "icon": "04d"
                    }
                  ],
                  "speed": 1.79,
                  "deg": 22,
                  "clouds": 92,
                  "pop": 0.01
                },
                {
                  "dt": 1615438800,
                  "sunrise": 1615417379,
                  "sunset": 1615460641,
                  "temp": {
                    "day": 36.34,
                    "min": 24.64,
                    "max": 38.5,
                    "night": 26.92,
                    "eve": 30.6,
                    "morn": 24.64
                  },
                  "feels_like": {
                    "day": 37.65,
                    "night": 26.29,
                    "eve": 29.08,
                    "morn": 26.13
                  },
                  "pressure": 1011,
                  "humidity": 32,
                  "weather": [
                    {
                      "id": 804,
                      "main": "Clouds",
                      "description": "overcast clouds",
                      "icon": "04d"
                    }
                  ],
                  "speed": 1.51,
                  "deg": 359,
                  "clouds": 85,
                  "pop": 0
                }
              ]
            }
        """
        let forecastModel = HNForecast(JSONString: forecastJson)!
        let forecastPageResponse = PagingEntity<HNForecast>(JSONString: forecastDailyJson)!
        
        beforeEach {
            mockRepository = MockForecastRespository()

            mockPresenter = MockHomePresenter()
            mockPresenter.stubbedShowErrorMessage = showErrorMessageTrigger
            mockPresenter.stubbedIsLoading = BehaviorRelay<Bool>(value: false)
            mockPresenter.stubbedHomeCellViewModels = BehaviorRelay<[HNHomeWeatherCellViewModel]>(value: [])
            
            mockRouter = MockHomeRouter()
            mockForecastService = MockForecastService()
            
            mockRepository.stubbedGetForecastDailyResult = .just(forecastPageResponse.items ?? [])
            
            sut = HNHomeViewModel(getMoviesUseCase:
                                    HNGetForecastDailyUseCase(
                                        repository: mockRepository
                                    )
            )
            
            mockForecastService.stubbedGetForecastDailyResult = .just(forecastPageResponse)
            
            sut.presenter = mockPresenter
            sut.router = mockRouter
            sut.didBecomeActive()
        }
        
        describe("View model will call api get movies SUCCESS") {
            beforeEach {
                sut.getForecastDailyAction.execute(("Saigon", 7, "metric"))
            }
            
            it("View model will send homeCellViewModels via presenter") {
                expect(mockPresenter.invokedHomeCellViewModelsGetter) == true
            }
            
            it("View model will send homeCellViewModels with first totalValue is 2") {
                expect(mockPresenter.homeCellViewModels.value.count) == 2
            }
            
            it("View model will send homeCellViewModels with fist averageTempareture") {
                expect(mockPresenter.homeCellViewModels.value.first?.average) == "31°C"
            }
            
            it("View model will send homeCellViewModels with fist pressure") {
                expect(mockPresenter.homeCellViewModels.value.first?.pressure) == "1012"
            }
            
            it("View model will send homeCellViewModels with fist humidity") {
                expect(mockPresenter.homeCellViewModels.value.first?.humidity) == "29%"
            }
            
            it("View model will send homeCellViewModels with fist description") {
                expect(mockPresenter.homeCellViewModels.value.first?.description) == "overcast clouds"
            }
            
            it("View model will send homeCellViewModels with last averageTempareture") {
                expect(mockPresenter.homeCellViewModels.value.last?.average) == "31°C"
            }
            
            it("View model will send homeCellViewModels with last pressure") {
                expect(mockPresenter.homeCellViewModels.value.last?.pressure) == "1011"
            }
            
            it("View model will send homeCellViewModels with last humidity") {
                expect(mockPresenter.homeCellViewModels.value.last?.humidity) == "32%"
            }
            
            it("View model will send homeCellViewModels with last description") {
                expect(mockPresenter.homeCellViewModels.value.last?.description) == "overcast clouds"
            }
            
            it("View model will send isLoading via presenter") {
                expect(mockPresenter.invokedIsLoadingGetter) == true
            }
        }
        
        describe("View model will call api get movies FAILED") {
            beforeEach {
                mockRepository.stubbedGetForecastDailyResult = .error(NSError.unknowError())
                it("View model will send errormessage via presenter") {
                    expect(mockPresenter.invokedShowErrorMessageGetter) == true
                }
                
                it("View model will send errormessage via presenter 1 time") {
                    expect(mockPresenter.invokedShowErrorMessageGetterCount) == 1
                }
            }
        }
        
        describe("User use pull to refresh") {
            beforeEach {
                sut.refreshTrigger.accept(())
            }
            
            it("View model will reload and send homeCellViewModels via presenter") {
                expect(mockPresenter.invokedHomeCellViewModelsGetter) == true
            }
            
            it("View model will send homeCellViewModels with totalValue is 0") {
                expect(mockPresenter.homeCellViewModels.value.count) == 0
            }
        }
        
        describe("User did select in movie Crone Wood") {
            beforeEach {
                sut.didSelectForecastTrigger.accept(nil)
            }
            it("View model will send router to movie detail") {
                expect(mockRouter.invokedGoToWeatherDetail) == true
                expect(mockRouter.invokedGoToWeatherDetailCount) == 1
            }
        }
        
        describe("Model parsing check") {
            it("Field") {
                expect(forecastModel.averageTempareture) == 30.85
                expect(forecastModel.pressure) == 1012
                expect(forecastModel.humidity) == 29
                expect(forecastModel.descriptionFormated) == "overcast clouds"
            }
        }
    }
}
