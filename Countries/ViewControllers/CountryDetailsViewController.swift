//
//  CountryDetailsViewController.swift
//  Countries
//
//  Created by Mikhail Polyevin on 18/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import RxCocoa
import RxSwift

class CountryDetailsViewController: UITableViewController {
    
    @IBOutlet private var borderLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var capitalLabel: UILabel!
    @IBOutlet private var currenciesLabel: UILabel!
    @IBOutlet private var populationLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    var viewModel: CountryDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewModel()
    }
    
    private func setupAppearance() {
        tableView.refreshControl = UIRefreshControl()
        title = "Country Details"
    }
    
    private func setupViewModel() {
        
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
            .asDriverOnErrorJustComplete()
        let input = CountryDetailsViewModel.Input(refresh: Driver.merge(viewWillAppear, pull))
        
        let output = viewModel.bind(input: input)
        
        output.countries.drive(onNext: { [weak self] (countryModel) in
            self?.nameLabel.text = countryModel.name
            self?.capitalLabel.text = countryModel.capital
            self?.populationLabel.text = countryModel.population
            self?.borderLabel.text = countryModel.borders
            self?.currenciesLabel.text = countryModel.currencies
        }).disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
