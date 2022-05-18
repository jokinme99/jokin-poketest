//
//  UIApplicationExtension.swift
//  Poke-test
//
//  Created by Jokin Egia on 27/4/22.
//

import UIKit

extension UIApplication {
     class func isFirstLaunch() -> Bool {
         if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
             UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
             UserDefaults.standard.synchronize()
             return true
         }
         return false
     }
 }
