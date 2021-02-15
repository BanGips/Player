//
//  TrackDetailView.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 11.02.21.
//

import UIKit
import Kingfisher
import AVKit

protocol TrackMovingDelegate {
    func moveForPreviouesTack() -> SearchViewModel.Cell?
    func moveForNextTack() -> SearchViewModel.Cell?
    
}

class TrackDetailView: UIView {
    @IBOutlet var playPauseButtons: [UIButton]!
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    @IBOutlet weak var miniPlayButton: UIButton!
    @IBOutlet weak var miniTackView: UIView!
    @IBOutlet weak var miniGoForwardButton: UIButton!
    @IBOutlet weak var maximaziedStackView: UIStackView!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniTrackTitleLabal: UILabel!
    
    let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        miniPlayButton.imageEdgeInsets = .init(top: 11, left: 11, bottom: 11, right: 11)
        setupGestureRecognizer()
    }
    
    func configure(viewModel: SearchViewModel.Cell) {
        miniTrackTitleLabal.text = viewModel.trackName
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observeCurrentTime()
        playPauseButtons.forEach { $0.setImage(#imageLiteral(resourceName: "pause"), for: .normal)}
        
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.kf.indicatorType = .activity
        trackImageView.kf.setImage(with: url)
        miniTrackImageView.kf.setImage(with: url)
    }
    
    private func setupGestureRecognizer() {
        miniTackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniTackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanMinimized)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    @objc private func handleDismiss(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: superview)
            maximaziedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.maximaziedStackView.transform = .identity
                if translation.y > 50 {
                    self.tabBarDelegate?.minimizeTrackDetailView()
                }
            }, completion: nil)
        @unknown default:
            print("Unknown")
        }
    }
    
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.maximizeTrackDetailView(viewModel: nil)
    }
    
    @objc private func handlePanMinimized(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        @unknown default:
            print("unknown")
        }
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        self.miniTackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximaziedStackView.alpha = -translation.y / 200
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.tabBarDelegate?.maximizeTrackDetailView(viewModel: nil)
            } else {
                self.miniTackView.alpha = 1
                self.maximaziedStackView.alpha = 0
            }
        }, completion: nil)
    }
    
    
    //MARK: - Time setup
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeImageView()
        }
    }
    
    private func observeCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "-\(currentDurationText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    //MARK: - Setup transform for Image
    
    private func enlargeImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
    }
    
    //MARK: - Actions
    
    @IBAction func drugDownButtonTapped(_ sender: UIButton) {
        tabBarDelegate?.minimizeTrackDetailView()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSecond = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSecond
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
        
    }
    
    @IBAction func handleValumeSlider(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func previousTrack(_ sender: UIButton) {
        let cellViewModel = delegate?.moveForPreviouesTack()
        guard cellViewModel != nil else { return }
        self.configure(viewModel: cellViewModel!)
    }
    
    @IBAction func nextTrack(_ sender: UIButton) {
        let cellViewModel = delegate?.moveForNextTack()
        guard cellViewModel != nil else { return }
        self.configure(viewModel: cellViewModel!)
        
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButtons.forEach { $0.setImage(#imageLiteral(resourceName: "pause"), for: .normal)}
            enlargeImageView()
        } else {
            player.pause()
            playPauseButtons.forEach { $0.setImage(#imageLiteral(resourceName: "play"), for: .normal)}
            reduceImageView()
        }
    }
    
}
