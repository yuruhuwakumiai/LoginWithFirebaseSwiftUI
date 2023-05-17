//
//  GoogleAuthView.swift
//  LoginFirebaseAppSwiftUI
//
//  Created by 橋元雄太郎 on 2023/05/18.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct GoogleAuthView: View {
    @EnvironmentObject var userAuth: UserAuth

    var body: some View {
        Button(action: {
            self.googleAuth()
        }) {
            HStack {
                Image(systemName: "globe")
                Text("Sign in with Google")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
    }

    func googleAuth() {

        guard let clientID:String = FirebaseApp.app()?.options.clientID else { return }
        let config:GIDConfiguration = GIDConfiguration(clientID: clientID)

        let windowScene:UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController:UIViewController? = windowScene?.windows.first!.rootViewController!

        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController!) { result, error in
            guard error == nil else {
                print("GIDSignInError: \(error!.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
            self.login(credential: credential)
        }
    }

    func login(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("SignInError: \(error.localizedDescription)")
                return
            } else {
                self.userAuth.isGoogleSignedIn = true
                self.userAuth.isShowingHomeView = true
            }
        }
    }
}
