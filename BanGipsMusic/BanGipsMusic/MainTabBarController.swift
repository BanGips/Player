//
//  MainTabBarController.swift
//  BanGipsMusic
//
//  Created by BanGips on 5.02.21.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
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
}
