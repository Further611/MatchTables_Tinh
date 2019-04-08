//
//  ScoreViewController.swift
//  MathTables
//
//  Created by TinhPV on 3/11/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
        
    }
    
    @IBOutlet weak var silverContainer: UIView!
    @IBOutlet weak var goldContainer: UIView!
    @IBOutlet weak var bronzeContainer: UIView!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var bronzeLabel: UILabel!
    
    @IBOutlet weak var scoreTableView: UITableView!
    
    let scoreSheet = UserDefaults.standard
    var scoreDict: [String : Int] = [:]
    var dateStringList: [String] = [String]()
    
    override func viewDidLayoutSubviews() {
        silverContainer.layer.cornerRadius = 15
        goldContainer.layer.cornerRadius = 15
        bronzeContainer.layer.cornerRadius = 15
        scoreTableView.tableFooterView = UIView.init(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configData()
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.StoryboardID.mainViewController) as! MainViewController
        self.present(vc, animated: true)
    }
    
    private func configData() {
        
        let goldCount = scoreSheet.integer(forKey: Constant.KeyUserDefaults.goldCount)
        let silverCount = scoreSheet.integer(forKey: Constant.KeyUserDefaults.silverCount)
        let bronzeCount = scoreSheet.integer(forKey: Constant.KeyUserDefaults.bronzeCount) 
        
        self.goldLabel.text = "\(goldCount)"
        self.silverLabel.text = "\(silverCount)"
        self.bronzeLabel.text = "\(bronzeCount)"
        
        self.scoreDict = scoreSheet.value(forKey: Constant.KeyUserDefaults.highScore) as! [String : Int]
        for (dateString, score) in scoreDict {
            self.dateStringList.append(dateString)
        }
        
    }

}


extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dateStringList.count > 6 {
            return 6
        } else {
            return dateStringList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scoreTableView.dequeueReusableCell(withIdentifier: Constant.CellID.scoreCell, for: indexPath) as! ScoreTableViewCell
        cell.dateLabel.text = self.dateStringList[indexPath.row]
        cell.scoreLabel.text = "\(self.scoreDict[self.dateStringList[indexPath.row]]!)"
        return cell
    }
    
    
}
