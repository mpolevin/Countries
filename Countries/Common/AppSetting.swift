//
//  AppSetting.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import Foundation

final class AppSetting {
    static let shared = AppSetting()
    
    let defaultBaseUrlString = "https://restcountries.eu/rest/v2"
    lazy var baseUrl = URL(string: defaultBaseUrlString)!
     
    private init() {}
}
