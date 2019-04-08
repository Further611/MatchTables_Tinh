//
//  AppDelegate.swift
//  MathTables
//
//  Created by TinhPV on 3/5/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let scoreSheet = UserDefaults.standard
        let initDict: [String : Int] = [:]
        let defaultValues = [Constant.KeyUserDefaults.goldCount : 0,
                             Constant.KeyUserDefaults.silverCount : 0,
                             Constant.KeyUserDefaults.bronzeCount : 0,
                             Constant.KeyUserDefaults.highScore : initDict] as [String : Any]
        scoreSheet.register(defaults: defaultValues)
        
        return true
    }
   
}

