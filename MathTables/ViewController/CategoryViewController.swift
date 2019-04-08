//
//  CategoryViewController.swift
//  MathTables
//
//  Created by TinhPV on 3/5/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import ChameleonFramework

class CategoryViewController: UIViewController {
    
    @IBOutlet var categoryButton: [UIButton]!
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
    }
    
    private func initUI() {
        for buttons in categoryButton {
            buttons.layer.cornerRadius = buttons.frame.width / 2
            buttons.frame.size = CGSize(width: 40, height: 40)
            buttons.backgroundColor = UIColor.init(randomFlatColorOf: .dark)
        }
    }
    
   

    @IBAction func numberPickerTapped(_ sender: Any) {
        MusicHelper.shared.play(name: "button_click")
        let numberPicked = (sender as! UIButton).tag
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.StoryboardID.learnViewController) as! LearnViewController
        vc.theFirstFactor = numberPicked
        self.present(vc, animated: true)
    }
    

}
