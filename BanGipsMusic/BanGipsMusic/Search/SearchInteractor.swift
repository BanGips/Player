//
//  SearchInteractor.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 8.02.21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    var networkService = NetworkService()
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        case .getTacks(text: let text):
            networkService.fetchTracks(searchText: text) { [ weak self] (searchResponse) in
                self? .presenter?.presentData(response: .presentTracks(searchResponse: searchResponse))
            }
        }
    }
    
}
