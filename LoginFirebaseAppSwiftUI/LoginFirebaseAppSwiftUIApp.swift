//
//  LoginFirebaseAppSwiftUIApp.swift
//  LoginFirebaseAppSwiftUI
//
//  Created by 橋元雄太郎 on 2023/05/17.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

// 追加設定
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

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
    @StateObject private var userAuth = UserAuth() // GoogleLoginのためUserAuthを使用可能にする

    var body: some Scene {
        WindowGroup {
            UserScreen()
                .environmentObject(userAuth)
        }
    }
}
