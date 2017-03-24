//
//  BackgroundAudio.swift
//  chihackathon
//
//  Created by Shitiz Gupta on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation

import AVFoundation
var backgroundMusicPlayer: AVAudioPlayer!
func playBackgroundMusic(filename: String) {
    let resourceUrl = Bundle.main.url(forResource:
        filename, withExtension: nil)
    guard let url = resourceUrl else {
        print("Could not find file: \(filename)")
        return
    }
    do {
        try backgroundMusicPlayer =
            AVAudioPlayer(contentsOf: url)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    } catch {
        print("Could not create audio player!")
        return
    } }
