//
//  ContentView.swift
//  LoginFirebaseAppSwiftUI
//
//  Created by 橋元雄太郎 on 2023/05/17.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct GoogleAuthView: View {
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
            }
        }
    }
}

struct ContentView: View {
    @StateObject var userAuth = UserAuth()
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    var body: some View {
        GoogleAuthView()
        if userAuth.isSignedIn {
            HomeView()
        } else {
            VStack {
                TextField("Email", text: $email)
                    .padding()
                    .border(Color.gray, width: 0.5)
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .padding()
                        .border(Color.gray, width: 0.5)
                } else {
                    SecureField("Password", text: $password)
                        .padding()
                        .border(Color.gray, width: 0.5)
                }
                Toggle(isOn: $isPasswordVisible) {
                    Text("パスワードを表示")
                }
                .padding(.bottom)
                if let error = userAuth.error {
                    Text(error)
                        .foregroundColor(.red)
                }
                if userAuth.isLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        userAuth.signUp(email: email, password: password)
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                    Button(action: {
                        userAuth.signIn(email: email, password: password)
                    }) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                    Button(action: {
                        userAuth.resetPassword(email: email)
                    }) {
                        Text("パスワードを忘れた方")
                            .foregroundColor(.blue)
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

