//
//  UIViewController + Extension.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 8.02.21.
//

import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error: No initial ViewController in \(name) storyboard")
        }
    }
}
