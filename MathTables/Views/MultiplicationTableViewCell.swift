//
//  MultiplicationTableViewCell.swift
//  MathTables
//
//  Created by TinhPV on 3/5/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class MultiplicationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstFactor: UILabel!
    @IBOutlet weak var secondFactor: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var leftContainer: UIView!
    @IBOutlet weak var rightContainer: UIView!
    
    
    var TwoFactors: (Int, Int)? {
        didSet {
            if let setOfTwo = TwoFactors {
                self.firstFactor.text = "\(setOfTwo.0)"
                self.secondFactor.text = "\(setOfTwo.1)"
                self.result.text = "\(setOfTwo.0 * setOfTwo.1)"
            } // end if let
        } // end didSet
    }
    
    override func layoutSubviews() {
//        readView.isHidden = true
        leftContainer.layer.cornerRadius = 20
        rightContainer.layer.cornerRadius = 20
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
