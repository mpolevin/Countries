//
//  AllCountriesViewModel.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import RxSwift
import RxCocoa

struct CountryCellModel {
    let name: String?
    
    init(country: Country) {
        name = country.name
    }
}

struct AllCountriesViewModel: ViewModelType {
    
    struct Input {
        let refresh: Driver<Void>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let selectedCountry: Driver<Country>
        let countries: Driver<[Country]>
        let fetching: Driver<Bool>
    }
    
    private let navigator: CountriesNavigator
    
    func bind(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let allCountriesDriver = input.refresh.flatMapLatest {
            return CountriesService
                .allContries()
                .trackActivity(activityIndicator)
                .debug()
                .asDriver(onErrorJustReturn: [])
        }
        
        let fetching = activityIndicator.asDriver()
        
        let selectedCountry = input.selection
            .withLatestFrom(allCountriesDriver) { (indexPath, countries) -> Country in
                return countries[indexPath.row]
            }
            .do(onNext: { country in //weak?
                self.navigator.toCountry(country)
            })
        
        return Output( selectedCountry: selectedCountry, countries: allCountriesDriver, fetching: fetching)
    }
    
    init(navigator: CountriesNavigator) {
        self.navigator = navigator
    }
    
}
