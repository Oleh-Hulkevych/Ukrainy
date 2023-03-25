//
//  SettingsView.swift
//  Ukrainy
//
//  Created by Hulkevych on 14.11.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State var showSignOutError: Bool = false
    
    @Binding var userDisplayName: String
    @Binding var userBio: String
    @Binding var userProfilePicture: UIImage
    
    var body: some View {
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                // Section #1: Ukrainy
                GroupBox {
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.white, lineWidth: 1)
                            )
                        
                        Text("Ukrainy - is the #1 app to show people the most beautiful places of Ukraine and share them with tourists from all over the world.")
                            .font(.footnote)
                    }
                } label: {
                    SettingsLabelView(labelText: "Ukrainy", labelImage: "dot.radiowaves.left.and.right")
                }
                .padding()
                
                // Section #2: Profile
                GroupBox {
                    
                    // Display Name
                    NavigationLink {
                        SettingsEditTextView(submissionText: userDisplayName, title: "Display Name", description: "Edit your display name.\nIt will be seen by the other users in your profile.\nAlso it will be displayed in your posts.\nLet's try: ''Rocky Balboa''", placeholder: "Enter your new display name here...", settingsEditTextOption: .displayName, profileText: $userDisplayName)
                    } label: {
                        SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.CustomColors.spaceCadet)
                    }
                    
                    // Bio
                    NavigationLink {
                        SettingsEditTextView(submissionText: userBio, title: "Biography", description: "Let's tell the users some cool things about you.\nIt will be displayed in your profile only.", placeholder: "Your biography here...", settingsEditTextOption: .bio, profileText: $userBio)
                    } label: {
                        SettingsRowView(leftIcon: "text.quote", text: "Biography", color: Color.CustomColors.spaceCadet)
                    }
                    
                    // Profile picture
                    NavigationLink {
                        SettingsEditImageView(title: "Profile Picture", description: "Your profule picture.\nIt will be seen by the other users in your profile.\nAlso it will be displayed in your posts.", selectedImage: userProfilePicture, profileImage: $userProfilePicture)
                    } label: {
                        SettingsRowView(leftIcon: "photo", text: "Profile picture", color: Color.CustomColors.spaceCadet)
                    }
                    
                    //Sign out
                    Button {
                        signOut()
                    } label: {
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign out", color: Color.CustomColors.spaceCadet)
                    }
                    .alert(isPresented: $showSignOutError) {
                        return Alert(title: Text("Error signing out!"))
                    }
                    
                } label: {
                    SettingsLabelView(labelText: "Profile", labelImage: "person.fill")
                }
                .padding()
                
                // Section #3: Application
                GroupBox {
                    
                    Button {
                        openCustomUrl(urlString: "https://github.com/Oleh-Hulkevych")
                    } label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.CustomColors.gold)
                    }
                    
                    Button {
                        openCustomUrl(urlString: "https://github.com/Oleh-Hulkevych")
                    } label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms & Conditions", color: Color.CustomColors.gold)
                    }
                    
                    Button {
                        openCustomUrl(urlString: "https://github.com/Oleh-Hulkevych")
                    } label: {
                        SettingsRowView(leftIcon: "globe", text: "Ukrainy Website", color: Color.CustomColors.gold)
                    }
                    
                } label: {
                    SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")
                }
                .padding()
                
                // Section #4: Sign off
                GroupBox {
                    Text("This app was made only for personal portfolio and not assigned for commercial use.\n\nHulkevych iDev Inc.\nSwiftUI 2022.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .padding(.bottom, 80)
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
            })
            .accentColor(.primary)
            )
        }
        .accentColor(colorScheme == .light ? Color.CustomColors.spaceCadet : Color.CustomColors.gold)
    }
    
    // MARK: - Methods
    
    func openCustomUrl(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func signOut() {
        AuthService.instance.signOutUser { (success) in
            if success {
                print("📗: Successfully logged out!")
                
                // Dimiss settings view
                self.presentationMode.wrappedValue.dismiss()
                
            } else {
                print("📕: Error logging out!")
                self.showSignOutError.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var testString: String = ""
    @State static var image: UIImage = UIImage(named: "Ukrainе003")!
    
    static var previews: some View {
        SettingsView(userDisplayName: $testString, userBio: $testString, userProfilePicture: $image)
            .preferredColorScheme(.dark)
    }
}
