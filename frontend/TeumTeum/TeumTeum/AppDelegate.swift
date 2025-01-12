//
//  AppDelegate.swift
//  TeumTeum
//
//  Created by 최유림 on 1/11/25.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var database: Firestore?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        self.database = Firestore.firestore()
        return true
    }
}
