//
//  CountryViewModel.swift
//  Countries
//
//  Created by Mikhail Polyevin on 18/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

struct CountryDetailsViewModel: ViewModelType {
    
    struct Input {
        let refresh: Driver<Void>
    }
    
    struct Output {
        let countries: Driver<[Country]>
        let fetching: Driver<Bool>
    }
    
    private let country: Country
    
    init(country: Country) {
        self.country = country
    }
    
    func bind(input: CountryDetailsViewModel.Input) -> CountryDetailsViewModel.Output {
        let activityIndicator = ActivityIndicator()
        
        let countries = input.refresh.flatMapLatest {
            return CountriesService
                .country(name: self.country.name ?? "")
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        
        let fetching = activityIndicator.asDriver()
        
        return Output.init(countries: countries, fetching: fetching)
    }
}
