//
//  FinishRegistrationView.swift
//  Ukrainy
//
//  Created by Hulkevych on 14.11.2022.
//

import SwiftUI

struct FinishRegistrationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var displayName: String
    @Binding var email: String
    @Binding var providerID: String
    @Binding var provider: String
    
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State var showError: Bool = false
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [ Color.CustomColors.timberwolf, Color.CustomColors.vanilla]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                
                Image("pray.large.emoji")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300, alignment: .center)
                    .shadow(color: .black.opacity(0.6), radius: 20, x: 0, y: 5)
                
                ZStack {
                    
                    VStack(alignment: .center, spacing: 20) {
                        
                        Text("Please enter your name:")
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.CustomColors.timberwolf)
                            .opacity(0.75)
                        
                        TextField("Your name?", text: $displayName)
                            .padding()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.CustomColors.timberwolf)
                            .cornerRadius(15)
                            .font(.title2)
                            .textInputAutocapitalization(.sentences)
                            .foregroundColor(Color.CustomColors.vanDyke)
                            .shadow(radius: 5)
                        
                        Text("Last step to complete:")
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.CustomColors.timberwolf)
                            .opacity(displayName != "" ? 0.75 : 0.0)
                        
                        Button {
                            showImagePicker.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "photo")
                                Text("Add profile picture")
                            }
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.CustomColors.vanilla)
                            .foregroundColor(Color.CustomColors.vanDyke)
                            .cornerRadius(15)
                            .font(.system(size: 23, weight: .semibold, design: .default))
                            .shadow(radius: 15)
                        }
                        .tint(Color.CustomColors.timberwolf)
                        .opacity(displayName != "" ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 1.0), value: true)
                    }
                }
                .padding(.all)
                .background(Color.CustomColors.vanDyke)
                .frame(maxWidth: .infinity)
                .cornerRadius(15)
                .shadow(color: .black, radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 25)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $showImagePicker) {
                createUserProfile()
            } content: {
                ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
            }
            .alert(isPresented: $showError) {
                return Alert(
                    title: Text("Error creating profile!"),
                    message: Text("Please try again!"))
            }
        }
    }
    
    // MARK: - Methods
    
    func createUserProfile() {
        
        AuthService.instance.createNewUserInDatabase(name: displayName, email: email, providerID: providerID, provider: provider, profileImage: imageSelected) { ( returnedUserID ) in
            
            if let userID = returnedUserID {
                AuthService.instance.signInUserToApp(userID: userID) { ( success ) in
                    if success {
                        print("📗: User signed in!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        print("📕: Error logging in!")
                        self.showError.toggle()
                    }
                }
            } else {
                print("📕: Error creating user in Database")
                self.showError.toggle()
            }
        }
    }
}

struct ObboardingViewPartTWO_Previews: PreviewProvider {
    
    @State static var testString = "Oleksandr"
    
    static var previews: some View {
        FinishRegistrationView(displayName: $testString, email: $testString, providerID: $testString, provider: $testString)
    }
}
