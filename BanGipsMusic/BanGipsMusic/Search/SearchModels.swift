//
//  SearchModels.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 8.02.21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getTacks(text: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks
      }
    }
  }
  
}
