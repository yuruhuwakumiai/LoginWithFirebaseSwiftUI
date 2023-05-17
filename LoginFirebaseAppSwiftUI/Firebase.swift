//
//  Firebase.swift
//  LoginFirebaseAppSwiftUI
//
//  Created by 橋元雄太郎 on 2023/05/17.
//

import SwiftUI
import FirebaseAuth


class UserAuth: ObservableObject {
    @Published var isGoogleSignedIn = false
    @Published var isMailSignedIn = false
    @Published var error: String?
    @Published var isLoading = false

    func signUp(email: String, password: String) {
        guard isValidEmail(email) else {
            error = "無効なメールアドレスです。"
            return
        }
        guard password.count >= 6 else {
            error = "パスワードは6文字以上である必要があります。"
            return
        }

        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.isLoading = false
            if let error = error {
                self.error = "エラー: \(error.localizedDescription)"
            } else {
                print("User \(authResult?.user.uid ?? "") created")
                self.isMailSignedIn = true
            }
        }
    }

    func signIn(email: String, password: String) {
        guard isValidEmail(email) else {
            error = "無効なメールアドレスです。"
            return
        }
        guard password.count >= 6 else {
            error = "パスワードは6文字以上である必要があります。"
            return
        }

        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.isLoading = false
            if let error = error {
                self.error = "エラー: \(error.localizedDescription)"
            } else {
                print("User \(authResult?.user.uid ?? "") signed in")
                self.isMailSignedIn = true
            }
        }
    }

    func resetPassword(email: String) {
        guard isValidEmail(email) else {
            error = "無効なメールアドレスです。"
            return
        }

        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.isLoading = false
            if let error = error {
                self.error = "エラー: \(error.localizedDescription)"
            } else {
                self.error = "パスワードリセットメールを送信しました。"
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}
