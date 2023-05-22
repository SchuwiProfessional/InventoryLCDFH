//
//  SwiftInventoryApp.swift
//  SwiftInventory
//
//  Created by Alvaro  on 9/05/23.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct SwiftInventoryApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
