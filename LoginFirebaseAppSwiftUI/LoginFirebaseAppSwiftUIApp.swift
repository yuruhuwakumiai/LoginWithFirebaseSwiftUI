//
//  LoginFirebaseAppSwiftUIApp.swift
//  LoginFirebaseAppSwiftUI
//
//  Created by 橋元雄太郎 on 2023/05/17.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

// GoogleSignIn設定
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
// Firebase設定
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
    // GoogleLoginのためUserAuthを使用可能にする
    @StateObject private var userAuth = UserAuth()

    var body: some Scene {
        WindowGroup {
            UserScreen()
                .environmentObject(userAuth)
        }
    }
}
