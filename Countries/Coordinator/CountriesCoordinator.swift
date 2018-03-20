//
//  CountriesCoordinator.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CountriesCoordinator {
    var errorPresenter: ErrorTracker { get }
    func toCountry(_ countryName: String)
    func toCountries()
}

final class DefaultCountriesCoordinator: CountriesCoordinator {
    private let storyboard: UIStoryboard
    private let navigationController: UINavigationController
    private let disposeBag = DisposeBag()
    
    lazy var errorPresenter: ErrorTracker = {
        let binder = Binder<Error>(self, binding: { (coordinator, error) in
            guard coordinator
                .navigationController
                .topViewController?
                .presentedViewController == nil else {
                    return
            }
            
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: .cancel)
            alert.addAction(action)
            coordinator
                .navigationController
                .topViewController?
                .present(alert, animated: true)
        })
        
        let tracker = ErrorTracker()
        tracker
            .throttle(AppSetting.shared.animationThrottleInterval)
            .drive(binder)
            .disposed(by: disposeBag)
        
        return tracker
    }()
    
    init(navigationController: UINavigationController,
         storyBoard: UIStoryboard) {
        self.navigationController = navigationController
        self.storyboard = storyBoard
    }
    
    func toCountries() {
        let vc = storyboard.instantiateViewController(ofType: CountriesListViewController.self)
        vc.viewModel = AllCountriesViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toCountry(_ countryName: String) {
        let viewModel = CountryDetailsViewModel(countryName: countryName,
                                                coordinator: self)
        let vc = storyboard.instantiateViewController(ofType: CountryDetailsViewController.self)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
