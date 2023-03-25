//
//  ProfileHeaderView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @Binding var profileDisplayName: String
    @Binding var profileImage: UIImage
    @Binding var profileBio: String
    
    @ObservedObject var postArray: PostArrayObject
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 170, height: 170, alignment: .center)
                .cornerRadius(85)
                .overlay(
                    RoundedRectangle(cornerRadius: 85)
                        .stroke(Color.CustomColors.timberwolf, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 2)
            
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if profileBio != "" {
                Text(profileBio)
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
            
            HStack(alignment: .center, spacing: 20) {
                
                VStack(alignment: .center, spacing: 5) {
                    
                    Text(postArray.postCountString)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Posts")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    
                    Text(postArray.likeCountString)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Likes")
                        .font(.callout)
                        .fontWeight(.medium)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    
    @State static var name: String = "Oleksandr"
    @State static var image: UIImage = UIImage(named: "user.large.emoji.white")!
    
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileImage: $image, profileBio: $name, postArray: PostArrayObject(shuffled: false))
            .previewLayout(.sizeThatFits)
    }
}
