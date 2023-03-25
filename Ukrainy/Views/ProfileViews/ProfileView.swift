//
//  ProfileView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var isMyProfile: Bool
    
    @State var profileDisplayName: String
    
    var profileUserId: String
    
    @State var profileBio: String = ""
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    var posts: PostArrayObject
    
    @State var showSettings: Bool = false
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage, profileBio: $profileBio, postArray: posts)
            
            Divider()
            ImageGridView(posts: posts)
        }
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    showSettings.toggle()
                                }, label: {
                                    Image(systemName: "line.horizontal.3")
                                })
                                    .accentColor(colorScheme == .light ? Color.CustomColors.spaceCadet : Color.CustomColors.vanilla)
                                .opacity(isMyProfile ? 1.0 : 0.0)
        )
        .onAppear(perform: {
            getProfileImage()
            getAdditionalProfileInfo()
        })
        .sheet(isPresented: $showSettings) {
            SettingsView(userDisplayName: $profileDisplayName, userBio: $profileBio, userProfilePicture: $profileImage)
                .preferredColorScheme(colorScheme)
        }
    }
    
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: profileUserId) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
    
    func getAdditionalProfileInfo() {
        AuthService.instance.getUserInfo(forUserID: profileUserId) { (returnedDisplayName, returnedBio) in
            if let displayName = returnedDisplayName {
                self.profileDisplayName = displayName
            }

            if let bio = returnedBio {
                self.profileBio = bio
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true, profileDisplayName: "Anton_TravelerUA", profileUserId: "", posts: PostArrayObject(userID: ""))
        }
    }
}
