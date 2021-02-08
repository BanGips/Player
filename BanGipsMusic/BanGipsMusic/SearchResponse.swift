//
//  SearchResponse.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 7.02.21.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
}
