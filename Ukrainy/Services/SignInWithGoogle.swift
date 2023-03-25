//
//  SignInWithGoogle.swift
//  Ukrainy
//
//  Created by Hulkevych on 15.11.2022.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

class SignInWithGoogle {
    
    // MARK: - Properties
    
    static let instance = SignInWithGoogle()
    private var welcomeView = WelcomeView()
    
    // MARK: - Methods
    
    func startSignInWithGoogleFlow(view: WelcomeView) {
        self.welcomeView = view
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = screen.windows.first?.rootViewController else { return }
        signIn(presenting: rootViewController)
    }
    
    private func signIn(presenting: UIViewController) {

        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
            
            if let error = error {
                print("📕: Error - \(error.localizedDescription)")
                self.welcomeView.showError.toggle()
            }
            
            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString else {
                    return
                }
            
            let accessToken = user.accessToken.tokenString
            
            guard
                let fullName = user.profile?.name,
                let email = user.profile?.email else {
                    return
                }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )
            
            self.welcomeView.connectToFirebase(
                name: fullName,
                email: email,
                provider: "google",
                credential: credential
            )
        }
    }
}
