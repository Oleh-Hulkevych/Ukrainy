//
//  UkrainyApp.swift
//  Ukrainy
//
//  Created by Hulkevych on 12.11.2022.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct UkrainyApp: App {
    
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView()
        }
    }
}
