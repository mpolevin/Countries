//
//  CountriesTarget.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import Moya

enum CountriesTarget {
    case all
    case country(String)
}

extension CountriesTarget: TargetType {
    var baseURL: URL {
        return AppSetting.shared.baseUrl 
    }
    
    var path: String {
        switch self {
        case .all:
            return "/all"
        case .country(let name):
            return "/name/\(name)"
        }
    }
    
    var method: Moya.Method  {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .all:
            return .requestParameters(parameters: ["fields" : ["name", "population"]], encoding: URLEncoding.default)
        case .country:
            return .requestParameters(parameters: ["fields" : ["name", "capital", "currencies", "population"]], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return .none
    }
}
