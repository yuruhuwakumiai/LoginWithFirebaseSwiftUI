//
//  ContentView.swift
//  LoginFirebaseAppSwiftUI
//
//  Created by 橋元雄太郎 on 2023/05/17.
//
import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var userAuth = UserAuth()
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    var body: some View {
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

