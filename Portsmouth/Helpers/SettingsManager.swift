import AVFoundation
import SwiftUI
import StoreKit

@MainActor
final class SettingsManager: ObservableObject {
    
    static let shared = SettingsManager()
    
    @Published var isSoundOn: Bool {
        didSet {
            defaults.set(isSoundOn, forKey: "soundOn")
            
            if !isSoundOn && isMusicOn {
                isMusicOn = false
            }
        }
    }
    
    @Published var isMusicOn: Bool {
        didSet {
            defaults.set(isMusicOn, forKey: "musicOn")
            
            if isMusicOn {
                if isSoundOn {
                    playMusic()
                } else {
                    isMusicOn = false
                }
            } else {
                stopMusic()
            }
        }
    }
    
    
    private let defaults = UserDefaults.standard
    private var audioPlayer: AVAudioPlayer?
    private var soundPlayer: AVAudioPlayer?
    
    private init() {
        self.isSoundOn = true
        self.isMusicOn = true
        
        if defaults.object(forKey: "soundOn") != nil {
            self.isSoundOn = defaults.bool(forKey: "soundOn")
        } else {
            defaults.set(true, forKey: "soundOn")
        }
        
        if defaults.object(forKey: "musicOn") != nil {
            self.isMusicOn = defaults.bool(forKey: "musicOn")
        } else {
            defaults.set(true, forKey: "musicOn")
        }
        
        setupAudioSession()
        prepareMusic()
        prepareSound()
    }
    
    // MARK: - Sound & Music
    func toggleSound() {
        isSoundOn.toggle()
    }
    
    func toggleMusic() {
        if !isSoundOn && !isMusicOn {
            return
        }
        isMusicOn.toggle()
    }
    
    func playSound() {
        guard isSoundOn, let player = soundPlayer else { return }
        
        player.currentTime = 0
        player.play()
    }
    
    func playMusic() {
        guard isSoundOn, isMusicOn, let player = audioPlayer, !player.isPlaying else { return }
        player.play()
    }
    
    func stopMusic() {
        audioPlayer?.pause()
    }
    
    // MARK: - Rate App
    func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    func openAppStoreForRating() {
        let appID = "6744395850"
        let urlString = "https://apps.apple.com/app/id\(appID)?action=write-review"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Private Methods
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func prepareMusic() {
        guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func prepareSound() {
        guard let url = Bundle.main.url(forResource: "click", withExtension: "mp3") else { return }
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
    }
}
