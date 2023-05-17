//
//  LoginFirebaseAppSwiftUIApp.swift
//  LoginFirebaseAppSwiftUI
//
//  Created by 橋元雄太郎 on 2023/05/17.
//

import SwiftUI
import FirebaseCore

// 追加設定
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct LoginFirebaseAppSwiftUIApp: App {
    // 追加設定
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
