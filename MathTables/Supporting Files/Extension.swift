//
//  Extension.swift
//  MathTables
//
//  Created by TinhPV on 3/10/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

extension UIButton {
    func addShadowTitle() {
        titleLabel!.layer.shadowColor = UIColor.darkGray.cgColor
        titleLabel!.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        titleLabel!.layer.shadowOpacity = 1.0
        titleLabel!.layer.shadowRadius = 0
        titleLabel!.layer.masksToBounds = false
    }
    
}


