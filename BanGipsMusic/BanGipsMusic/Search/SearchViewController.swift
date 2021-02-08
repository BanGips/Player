//
//  SearchViewController.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 8.02.21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
    
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    private var searchViewModel = SearchViewModel(cell: [ ])
    
    var timer: Timer?
    
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: TrackCell.reuseID)
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTracks(searchViewModel: let searchViewModel):
            self.searchViewModel = searchViewModel
            tableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseID, for: indexPath) as! TrackCell
        
        let cellViewModel = searchViewModel.cell[indexPath.row]
        cell.configure(viewModel: cellViewModel) 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}

//MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.interactor?.makeRequest(request: .getTacks(text: searchText))
        })
        
    }
    
}
