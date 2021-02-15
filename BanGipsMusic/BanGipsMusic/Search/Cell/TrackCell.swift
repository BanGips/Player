//
//  TrackCell.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 8.02.21.
//

import UIKit
import Kingfisher

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
    var cell: SearchViewModel.Cell?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackImageView.image = nil 
    }
    
    func configure(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        trackNameLabel.text = viewModel.trackName
        artistNameLabal.text = viewModel.artistName
        colectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.kf.setImage(with: url)
    }
    @IBAction func addTrackAction(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: cell, requiringSecureCoding: false) {
            defaults.set(saveData, forKey: "track")
            print("YEEP")
        }
        
        if let savedTrack = defaults.object(forKey: "track") as? Data {
            if let decodedTrack = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTrack) as? SearchViewModel.Cell {
                print(decodedTrack.trackName, decodedTrack.artistName)
            }
        }
    }
}
