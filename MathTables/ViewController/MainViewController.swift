//
//  LearnViewController.swift
//  MathTables
//
//  Created by TinhPV on 3/5/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import Lottie

class MainViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func moveToVC(identifier: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        self.present(vc!, animated: true)
    }
    
    @IBAction func scoreButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.StoryboardID.scoreViewController) as! ScoreViewController
        self.present(vc, animated: true)
    }
    
    
    @IBAction func learnButtonTapped(_ sender: Any) {
        MusicHelper.shared.play(name: "button_click")
        self.moveToVC(identifier: Constant.StoryboardID.categoryViewController)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        MusicHelper.shared.play(name: "button_click")
        self.moveToVC(identifier: Constant.StoryboardID.playViewController)
    }
    
    @IBAction func practiceButtonTapped(_ sender: Any) {
        MusicHelper.shared.play(name: "button_click")
        self.moveToVC(identifier: Constant.StoryboardID.practiceViewController)
    }
    
}
