//
//  TrackCell.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 8.02.21.
//

import UIKit

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var artistName: String { get }
    var trackName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var artistNameLabal: UILabel!
    @IBOutlet weak var colectionNameLabel: UILabel!
    
    static let reuseID = "TrackCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(viewModel: TrackCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabal.text = viewModel.artistName
        colectionNameLabel.text = viewModel.collectionName
    }
}
