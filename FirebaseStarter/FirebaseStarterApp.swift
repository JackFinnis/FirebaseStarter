//
//  FirebaseStarterApp.swift
//  FirebaseStarter
//
//  Created by Jack Finnis on 18/10/2021.
//

import SwiftUI
import Firebase

@main
struct FirebaseStarterApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase with project
        FirebaseApp.configure()
        return true
    }
}
