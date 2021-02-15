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
    private lazy var footerView = FooterView()
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
        tabBarVC?.trackDetailView.delegate = self
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: TrackCell.reuseID)
        tableView.tableFooterView = footerView
        
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
            footerView.hideLoader()
        case .displayFooterView:
            footerView.showLoader()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above.."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        return label
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cell.count > 0 ? 0 : 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cell[indexPath.row]
        
        self.tabBarDelegate?.maximizeTrackDetailView(viewModel: cellViewModel)
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

extension SearchViewController: TrackMovingDelegate {
    private func getTrack(isFrowardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isFrowardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == searchViewModel.cell.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = searchViewModel.cell.count - 1
            }
        }
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellViewModel = searchViewModel.cell[nextIndexPath.row]
        return cellViewModel
    }
    
    func moveForPreviouesTack() -> SearchViewModel.Cell? {
        return getTrack(isFrowardTrack: false)
    }
    
    func moveForNextTack() -> SearchViewModel.Cell? {
        return getTrack(isFrowardTrack: true)
    }
    
    
}
