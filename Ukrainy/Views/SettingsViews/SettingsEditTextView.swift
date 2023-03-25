//
//  SettingsEditTextView.swift
//  Ukrainy
//
//  Created by Hulkevych on 14.11.2022.
//

import SwiftUI

struct SettingsEditTextView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    @State var settingsEditTextOption: SettingsEditTextOption
    
    @Binding var profileText: String
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @State var showSuccessAlert: Bool = false
    
    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [ Color.CustomColors.timberwolf, Color.CustomColors.vanilla,]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Image("funny.large.emoji")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320, alignment: .center)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 20, y: 2)
                    .padding(.bottom, -30)
                
                HStack {
                    
                    Text(description)
                        .multilineTextAlignment(.center)
                        .tint(Color.CustomColors.spaceCadet)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                
                TextField(placeholder, text: $submissionText)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.CustomColors.timberwolf)
                    .cornerRadius(15)
                    .font(.headline)
                    .textInputAutocapitalization(.sentences)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.CustomColors.spaceCadet, lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Button {
                    if textIsAppropriate() {
                        saveText()
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image("save.custom")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                        
                        Text("Save")
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.CustomColors.spaceCadet)
                    .cornerRadius(15)
                    .font(.system(size: 23, weight: .semibold, design: .default))
                }
                .tint(Color.CustomColors.vanilla)
                .shadow(color: .black.opacity(0.75), radius: 10, x: 0, y: 2)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .navigationBarTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showSuccessAlert) {
                return Alert(title: Text("Saved!"), message: nil, dismissButton: .default(Text("OK"), action: {
                    dismissView()
                }))
            }
        }
    }
    
    // MARK: - METHODS
    
    func dismissView() {
        self.haptics.notificationOccurred(.success)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func textIsAppropriate() -> Bool {

        let badWordArray: [String] = ["shit", "ass", "fuck", "piss off", "bloody hell", "bastard", "motherfucker", "son of a bitch", "asshole", "bollocks"]
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        // Checking for minimum character count
        if submissionText.count < 3 {
            return false
        }
        return true
    }
    
    func saveText() {
        
        guard let userID = currentUserID else { return }
        
        switch settingsEditTextOption {
        case .displayName:
            
            // Update the UI on the Profile
            self.profileText = submissionText
            
            // Update the UserDefault
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.displayName)
            
            // Update on all of the user's posts
            DataService.instance.updateDisplayNameOnPosts(userID: userID, displayName: submissionText)
            
            // Update on the user's profile in DB
            AuthService.instance.updateUserDisplayName(userID: userID, displayName: submissionText) { (success) in
                if success {
                    self.showSuccessAlert.toggle()
                }
            }
            
        case .bio:
            
            // Update the UI on the Profile
            self.profileText = submissionText
            
            // Update the UserDefault
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.bio)
            
            // Update on the user's profile in DB
            AuthService.instance.updateUserBio(userID: userID, bio: submissionText) { (success) in
                if success {
                    self.showSuccessAlert.toggle()
                }
            }
        }
    }
}

struct SettingsEditTextView_Previews: PreviewProvider {
    
    @State static var text: String = ""
    
    static var previews: some View {
        NavigationView {
            SettingsEditTextView(title: "Display Name", description: "Edit your display name.\nIt will be seen by the other users in your profile.\nAlso it will be displayed in your posts.\nLet's try: ''Rocky Balboa''", placeholder: "Enter your new display name here...", settingsEditTextOption: .displayName, profileText: $text)
                .preferredColorScheme(.light)
        }
    }
}
