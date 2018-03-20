//
//  CountryViewModel.swift
//  Countries
//
//  Created by Mikhail Polyevin on 18/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import RxSwift
import RxCocoa

struct CountryDetailsPresentationModel {
    let name: String
    let borders: String
    let capital: String
    let currencies: String
    let population: String
    
    init(with country: Country) {
        name = country.name ?? ""
        population = String(country.population ?? 0)
        capital = country.capital ?? "No Capital"
        
        currencies = country.currencies?
            .flatMap {
                [$0.name, $0.symbol].flatMap { $0 }
                    .joined(separator: " ")
            }.joined(separator: ", ") ?? "No Currencies"
        
        borders = country.borders?
            .joined(separator: ", ") ?? "No Borders"
    }
    
}

struct CountryDetailsViewModel: ViewModelType {
    
    struct Input {
        let refresh: Driver<Void>
    }
    
    struct Output {
        let countries: Driver<CountryDetailsPresentationModel>
        let fetching: Driver<Bool>
    }
    
    private let coordinator: CountriesCoordinator
    private let countryName: String
    
    init(countryName: String, coordinator: CountriesCoordinator) {
        self.countryName = countryName
        self.coordinator = coordinator
    }
    
    func bind(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let countries = input.refresh.flatMapLatest {
            return CountriesService
                .country(name: self.countryName)
                .map {
                    CountryDetailsPresentationModel(with: $0[0])
                }
                .trackActivity(activityIndicator)
                .trackError(self.coordinator.errorPresenter)
                .retry(AppSetting.shared.numberOfRetryAttempts)
                .asDriverOnErrorJustComplete()
        }
        
        let fetching = activityIndicator.asDriver()
        
        return Output(
            countries: countries,
            fetching: fetching
        )
    }
}
