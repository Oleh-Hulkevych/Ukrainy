//
//  WelcomeView.swift
//  Ukrainy
//
//  Created by Hulkevych on 14.11.2022.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

struct WelcomeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showFinishRegistrationView: Bool = false
    @State var showError: Bool = false
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var providerID: String = ""
    @State var provider: String = ""
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [ Color.CustomColors.timberwolf, Color.CustomColors.vanilla,]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 15) {

                Image("welcome.large.emoji")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320, alignment: .center)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 2)

                VStack(spacing: 15) {

                    Text("Welcome to Ukrainy!")
                        .font(.system(size: 32))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.CustomColors.spaceCadet)
                        .shadow(radius: 10)

                    Text("Ukrainy is the #1 app to show people the most beautiful places of Ukraine and share them with tourists from all over the world.")
                        .font(.headline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.CustomColors.spaceCadet)
                        .shadow(radius: 10)
                }

                VStack(spacing: 20) {
                    
                    Text("We will be glad to have you with us!")
                        .font(.headline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.CustomColors.spaceCadet)
                        .shadow(radius: 10)
                    
                    Button {
                        SignInWithGoogle.instance.startSignInWithGoogleFlow(view: self)
                    } label: {
                        HStack {
                            Image("google-logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                            Text("Sign in with Google")
                        }
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .font(.system(size: 23, weight: .semibold, design: .default))
                    }
                    .tint(Color.black)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 2)

                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.questionmark.fill")
                                .font(.title)
                            Text("Continue as Guest")
                        }
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.CustomColors.spaceCadet)
                        .cornerRadius(15)
                        .font(.system(size: 23, weight: .semibold, design: .default))

                    }
                    .tint(Color.CustomColors.vanilla)
                    .shadow(color: .black.opacity(0.75), radius: 10, x: 0, y: 2)
                }
            }
            .padding(.all, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            
            .fullScreenCover(isPresented: $showFinishRegistrationView, onDismiss: {
                self.presentationMode.wrappedValue.dismiss()
            }, content: {
                FinishRegistrationView(displayName: $displayName, email: $email, providerID: $providerID, provider: $provider)
            })
            .alert(isPresented: $showError) {
                return Alert(
                    title: Text("Error signing in!"),
                    message: Text("Please try again to sign in or press ''sign up'' button to become a member!"))
            }
        }
    }
    
    // MARK: Methods
    
    func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
        
        AuthService.instance.signInUserToFirebase(credential: credential) { (returnedProviderID, isError, isNewUser, returnedUserID) in
            if let newUser = isNewUser {
                if newUser {
                    // Sign up new user
                    if let providerID = returnedProviderID, !isError {
                        self.displayName = name
                        self.email = email
                        self.providerID = providerID
                        self.provider = provider
                        self.showFinishRegistrationView.toggle()
                    } else {
                        print("📕: Error getting provider ID!")
                        self.showError.toggle()
                    }
                } else {
                    // Sign in existing user
                    if let userID = returnedUserID {
                        AuthService.instance.signInUserToApp(userID: userID) { (success) in
                            if success {
                                print("📗: Successful sign in existing user!")
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                print("📕: Error signing existing user!")
                                self.showError.toggle()
                            }
                        }
                    } else {
                        print("📕: Error getting user id from existing user to Firebase!")
                        self.showError.toggle()
                    }
                }
            } else {
                print("📕: Error getting into from log in user to Firebase!")
                self.showError.toggle()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
