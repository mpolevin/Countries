import UIKit

protocol CountriesNavigator {
    func toCountry(_ country: Country)
    func toCountries()
}

final class DefaultCountriesNavigator: CountriesNavigator {
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController,
         storyBoard: UIStoryboard) {
        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }
    
    func toCountries() {
        let vc = storyBoard.instantiateViewController(ofType: CountriesListViewController.self)
        vc.viewModel = AllCountriesViewModel(navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func toCountry(_ country: Country) {
        let viewModel = CountryDetailsViewModel.init(country: country)
        
        let vc = storyBoard.instantiateViewController(ofType: CountryDetailsViewController.self)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)        
    }
}
