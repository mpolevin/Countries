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
    
    private let defaultBaseUrlString = "https://restcountries.eu/rest/v2"
    lazy var baseUrl = URL(string: defaultBaseUrlString)!
    let numberOfRetryAttempts = 3
    let animationThrottleInterval = 0.3
    
    private init() {}
}
