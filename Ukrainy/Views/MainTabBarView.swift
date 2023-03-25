//
//  MainTabBarView.swift
//  Ukrainy
//
//  Created by Hulkevych on 12.11.2022.
//

import SwiftUI

struct MainTabBarView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    let feedPosts = PostArrayObject(shuffled: false)
    let browsePosts = PostArrayObject(shuffled: true)
    
    var body: some View {
        TabView {
            
            NavigationView {
                UkrainyView(post: feedPosts, title: "Ukrainy")
            }
            .tabItem {
                Image("ukrainy.logo.icon")
                    .resizable()
                
                    .renderingMode(.template)
                    .font(.title2)
                
                Text("Ukrainy")
            }
            
            NavigationView {
                PlacesView(posts: browsePosts)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Places")
            }
            
            UploadView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Upload")
                }
            
            ZStack {
                if let usersID = currentUserID, let displayName = currentUserDisplayName {
                    NavigationView {
                        ProfileView(isMyProfile: true, profileDisplayName: displayName, profileUserId: usersID, posts: PostArrayObject(userID: usersID))
                    }
                } else {
                    SignUpView()
                }
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
                
            }
        }
        .onAppear {
            // Correct the transparency bug for Tab bars
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        .accentColor(colorScheme == .light ? Color.CustomColors.spaceCadet : Color.CustomColors.vanilla)
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
            .preferredColorScheme(.dark)
    }
}
