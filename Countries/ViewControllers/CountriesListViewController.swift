//
//  ViewController.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

//Обработка ошибок
//FILTER RESPONSE.
import RxSwift
import RxCocoa

class CountriesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: AllCountriesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        tableView.refreshControl = UIRefreshControl()
        
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
            .asDriver(onErrorJustReturn: ())
        let itemSelected = tableView.rx.itemSelected
        
        let input = AllCountriesViewModel.Input(refresh: Driver.merge(viewWillAppear, pull), selection: itemSelected.asDriver())
        
        let output = viewModel.bind(input: input)
        
        output.selectedCountry
            .drive()
            .disposed(by: disposeBag)
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        //WARNING: should use cell model
        output.countries.drive(tableView.rx.items(cellIdentifier: "TableViewCell", cellType: UITableViewCell.self)) { tv, viewModel, cell in
            cell.textLabel?.text = viewModel.name
            cell.detailTextLabel?.text = "Population: \(viewModel.population ?? 0)"
            }.disposed(by: disposeBag)
    }
}
