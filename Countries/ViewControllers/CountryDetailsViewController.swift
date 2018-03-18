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
        tableView.refreshControl = UIRefreshControl()
        title = "Country Details"
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
            .asDriver(onErrorJustReturn: ())
        let input = CountryDetailsViewModel.Input(refresh: Driver.merge(viewWillAppear, pull))
        
        let output = viewModel.bind(input: input)
        
        output.countries.drive(onNext: { (countries) in
            if let country = countries.first {
                self.nameLabel.text = country.name
                self.capitalLabel.text = country.capital
                self.populationLabel.text = String(country.population ?? 0)
                
                if let currencies = country.currencies {
                    var currencyString = ""
                    currencyString = currencies.map { "\($0.name ?? "") (\($0.symbol ?? ""))" }
                        .joined(separator: ", ")
                    self.currenciesLabel.text = currencyString
                }
                else {
                    self.currenciesLabel.text = ""
                }
                
                if let borders = country.borders {
                    let joiner = ", "
                    self.borderLabel.text = borders.joined(separator: joiner)
                }
            }
        }).disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
