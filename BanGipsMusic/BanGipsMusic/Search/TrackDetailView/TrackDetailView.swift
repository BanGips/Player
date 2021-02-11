//
//  TrackDetailView.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 11.02.21.
//

import UIKit

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var AuthorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func drugDownButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
    }
    @IBAction func handleValumeSlider(_ sender: UISlider) {
    }
    @IBAction func previousTrack(_ sender: UIButton) {
    }
    @IBAction func nextTrack(_ sender: UIButton) {
    }
    @IBAction func playPauseAction(_ sender: UIButton) {
    }
    
}
