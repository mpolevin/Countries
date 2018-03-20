//
//  ViewController.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

import RxSwift
import RxCocoa

class CountriesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: AllCountriesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewModel()
    }
    
    private func setupAppearance() {
        title = "Countries"
        tableView.refreshControl = UIRefreshControl()
    }
    
    private func setupViewModel() {
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
            .asDriverOnErrorJustComplete()
        let itemSelected = tableView.rx.itemSelected
        
        let input = AllCountriesViewModel.Input(refresh: Driver.merge(viewWillAppear, pull), selection: itemSelected.asDriver())
        
        let output = viewModel.bind(input: input)
        
        output.selectedCountry
            .drive()
            .disposed(by: disposeBag)
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.countries.drive(tableView.rx.items(cellIdentifier: "TableViewCell", cellType: UITableViewCell.self)) { i, model, cell in
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.population
            }.disposed(by: disposeBag)
    }
}
