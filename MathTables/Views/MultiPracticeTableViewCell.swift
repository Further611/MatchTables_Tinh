//
//  MultiPracticeTableViewCell.swift
//  MathTables
//
//  Created by TinhPV on 3/5/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

protocol PanGestureInCellDelegate {
    func panStart(gesture: UIPanGestureRecognizer, resultLabel: String, indexPathOfCurrentCell: IndexPath, frameOfLabel: CGRect)
}

class MultiPracticeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstFactor: UILabel!
    @IBOutlet weak var secondFactor: UILabel!
    @IBOutlet weak var equalSign: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var leftContainer: UIView!
    @IBOutlet weak var rightContainer: UIView!
    
    var superViewController: UIViewController!
    var originPositionOfResultLabel: CGRect!
    
    var isAlreadyChoosen: Bool = false
    
    var delegate: PanGestureInCellDelegate?
    
    var TwoFactors: (Int, Int)? {
        didSet {
            if let setOfTwo = TwoFactors {
                self.firstFactor.text = "\(setOfTwo.0)"
                self.secondFactor.text = "\(setOfTwo.1)"
                self.leftContainer.backgroundColor = #colorLiteral(red: 0.9941957593, green: 0.7495155931, blue: 0.178378284, alpha: 1)
                self.equalSign.textColor = #colorLiteral(red: 0.9941957593, green: 0.7495155931, blue: 0.178378284, alpha: 1)
            } // end if let
        } // end didSet
    }
    
    var intResult: Int? {
        didSet {
            
            if intResult != nil {
                self.originPositionOfResultLabel = self.result.frame
                let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
                self.result.addGestureRecognizer(pan)
                self.result.isUserInteractionEnabled = true
                self.result.text = "\(self.intResult!)"
                self.rightContainer.backgroundColor = #colorLiteral(red: 0.9941957593, green: 0.7495155931, blue: 0.178378284, alpha: 1)
            } else {
                self.result.gestureRecognizers?.removeAll()
                self.result.isUserInteractionEnabled = false
                
                self.result.text = "??"
                self.rightContainer.backgroundColor = #colorLiteral(red: 0, green: 0.7605708838, blue: 0.6468440294, alpha: 1)
               
            }
        } // end didSet
    }
    
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        let indexPath = IndexPath(row: self.tag, section: 0)
        self.result.isHidden = true
        
        self.delegate?.panStart(gesture: sender, resultLabel: "\(intResult!)", indexPathOfCurrentCell: indexPath, frameOfLabel: originPositionOfResultLabel)
    }

    override func layoutSubviews() {
        self.result.text = "??"
        leftContainer.layer.cornerRadius = 20
        rightContainer.layer.cornerRadius = 20
//        leftContainer.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.7490196078, blue: 0.1764705882, alpha: 1)
//        rightContainer.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.7490196078, blue: 0.1764705882, alpha: 1)
//        equalSign.textColor = #colorLiteral(red: 0.9960784314, green: 0.7490196078, blue: 0.1764705882, alpha: 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
