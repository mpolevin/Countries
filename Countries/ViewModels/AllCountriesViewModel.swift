//
//  AllCountriesViewModel.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import RxSwift
import RxCocoa

struct CountryPresentationModel {
    let name: String
    let population: String
    
    init(with country: Country) {
        name = country.name ?? ""
        population = "Population: \(String(country.population ?? 0))"
    }
}

struct AllCountriesViewModel: ViewModelType {
    
    struct Input {
        let refresh: Driver<Void>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let selectedCountry: Driver<CountryPresentationModel>
        let countries: Driver<[CountryPresentationModel]>
        let fetching: Driver<Bool>
    }
    
    private let coordinator: CountriesCoordinator
    
    func bind(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let allCountriesDriver = input.refresh.flatMapLatest {
            return CountriesService
                .allContries()
                .map { countries in
                    return countries.map {
                        CountryPresentationModel(with: $0)
                    }
                }
                .trackActivity(activityIndicator)
                .trackError(self.coordinator.errorPresenter)
                .retry(AppSetting.shared.numberOfRetryAttempts)
                .asDriverOnErrorJustComplete()
        }
        
        let fetching = activityIndicator.asDriver()
        
        let selectedCountry = input.selection
            .withLatestFrom(allCountriesDriver) { indexPath, countries in
                return countries[indexPath.row]
            }
            .do(onNext: { country in
                guard !country.name.isEmpty else { return }
                self.coordinator.toCountry(country.name)
            })
        
        return Output(
            selectedCountry: selectedCountry,
            countries: allCountriesDriver,
            fetching: fetching
        )
    }
    
    init(coordinator: CountriesCoordinator) {
        self.coordinator = coordinator
    }
}
