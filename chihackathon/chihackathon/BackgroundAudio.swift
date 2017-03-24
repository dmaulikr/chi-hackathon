//
//  BackgroundAudio.swift
//  chihackathon
//
//  Created by Shitiz Gupta on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: NSObject {
    
    static let sharedInstance = AudioManager()
    
    private var player = AVAudioPlayer()
    
    func playBackgroundMusic(filename: String) {
        if let resourcePath = Bundle.main.path(forResource: filename, ofType: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: resourcePath))
                player.numberOfLoops = -1
                player.play()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopMusic() {
        player.stop()
    }
    
}
