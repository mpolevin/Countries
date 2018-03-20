//
//  CountriesService.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import Moya
import RxSwift

final class CountriesService {
    private static let provider = MoyaProvider<CountriesTarget>()
    
    static func allContries() -> Observable<[Country]> {
        return provider.rx.request(.all)
            .map([Country].self)
            .asObservable()
    }
    
    static func country(name: String) -> Observable<[Country]> {
        return provider.rx.request(.country(name))
            .map([Country].self)
            .asObservable()
    }
    
}
