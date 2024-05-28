//
//  MusicPlayer.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 27.05.2024.
//

import SwiftUI
import AVFoundation

class AudioPlayer: ObservableObject {
    @AppStorage("isSoundOn") var isSoundOn: Bool = true
    
    @Published var isPlaying = true
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(sound: String, type: String, isSoundOn: Bool) {
        guard isSoundOn else { return } // Check if sound is enabled
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("ERROR: Could not find and play the sound file!")
            }
        }
    }
    
    func playBackgroundMusic(fileName: String, fileType: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            print("Failed to locate audio file.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to initialize audio player: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
        isPlaying.toggle()
    }
}
