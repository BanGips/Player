//
//  MainTabBarController.swift
//  BanGipsMusic
//
//  Created by BanGips on 5.02.21.
//

import UIKit

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailView()
    func maximizeTrackDetailView(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    private var maxTopAnchor: NSLayoutConstraint!
    private var minTopAnchor: NSLayoutConstraint!
    private var bottomAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrackDetailView()
        
        let libraryVC = ViewController()
        tabBar.tintColor = .magenta
        
        viewControllers = [
            generateNavigationController(rootVC: searchVC, title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(rootVC: libraryVC, title: "Library", image: #imageLiteral(resourceName: "library"))
        ]
        
        searchVC.tabBarDelegate = self
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
    }
    
    private func generateNavigationController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        rootVC.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
    private func setupTrackDetailView() {
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        maxTopAnchor = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minTopAnchor = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maxTopAnchor.isActive = true
        
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomAnchor = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchor.isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    func maximizeTrackDetailView(viewModel: SearchViewModel.Cell?) {
        minTopAnchor.isActive = false
        maxTopAnchor.isActive = true
        maxTopAnchor.constant = 0
        bottomAnchor.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = true
            self.trackDetailView.miniTackView.alpha = 0
            self.trackDetailView.maximaziedStackView.alpha = 1
        }, completion: nil)
        
        guard let viewModel = viewModel else { return }
        self.trackDetailView.configure(viewModel: viewModel)
        
    }
    
    func minimizeTrackDetailView() {
        maxTopAnchor.isActive = false
        bottomAnchor.constant = view.frame.height
        minTopAnchor.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = false
            self.trackDetailView.miniTackView.alpha = 1
            self.trackDetailView.maximaziedStackView.alpha = 0
        }, completion: nil)
    }
    
}
