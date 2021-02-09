//
//  FooterView.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 9.02.21.
//

import UIKit

class FooterView: UIView {
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(label)
        addSubview(loader)
        
        loader.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        loader.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        loader.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8).isActive = true
    }
    
    func showLoader() {
        loader.startAnimating()
        label.text = "LOADING"
    }
    
    func hideLoader() {
        loader.stopAnimating()
        label.text = ""
    }
    
}
