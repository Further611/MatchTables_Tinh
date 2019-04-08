//
//  MusicHelper.swift
//  MathTables
//
//  Created by TinhPV on 3/10/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import Foundation
import AVFoundation

class MusicHelper {
    static let shared = MusicHelper()
    var audioPlayer: AVAudioPlayer?
    
    func play(name: String) {
        
        let url = Bundle.main.url(forResource: name, withExtension: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = audioPlayer else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    } // end method
}

