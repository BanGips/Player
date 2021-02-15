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
    @IBOutlet weak var addTrack: UIButton!
    
    static let reuseID = "TrackCell"
    var cell: SearchViewModel.Cell?
    let defaults = UserDefaults.standard
    
    
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
        let savedTrack = defaults.savedTracks()
        
        let hasAdded = savedTrack.firstIndex(where: { $0.trackName.lowercased() == self.cell?.trackName.lowercased() && $0.artistName.lowercased() == self.cell?.artistName.lowercased()}) != nil
        if hasAdded {
            addTrack.isHidden = true
        } else {
            addTrack.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabal.text = viewModel.artistName
        colectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.kf.setImage(with: url)
    }
    @IBAction func addTrackAction(_ sender: UIButton) {
        addTrack.isHidden = true
        guard let cell = cell else { return }
        var listOfTracks = defaults.savedTracks()
        
        listOfTracks.append(cell)
        
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            defaults.set(saveData, forKey: UserDefaults.favoriteTrackKey)
        }
    }
}
