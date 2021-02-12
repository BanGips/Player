//
//  MainTabBarController.swift
//  BanGipsMusic
//
//  Created by BanGips on 5.02.21.
//

import UIKit

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailView() 
}

class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    
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
        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maxTopAnchor = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor)
        minTopAnchor = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maxTopAnchor.isActive = true
        bottomAnchor = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    func minimizeTrackDetailView() {
        maxTopAnchor.isActive = false
        minTopAnchor.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
