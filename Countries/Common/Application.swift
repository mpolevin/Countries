//
//  Application.swift
//  Countries
//
//  Created by Mikhail Polyevin on 18/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import Foundation
import UIKit

final class Application {
    static let shared = Application()
    
    private init() {}
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = UINavigationController()
        let countriesCoordinator = DefaultCountriesCoordinator(navigationController: navigationController, storyBoard: storyboard)
        window.rootViewController = navigationController
        
        countriesCoordinator.toCountries()
    }
}

