//
//  MessegeView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct MessegeView: View {
    
    @State var comment: CommentModel
    @State var profilePicture: UIImage = UIImage(named: "user.large.emoji.white")!
    
    var body: some View {
        HStack {
            
            NavigationLink {
                LazyView {
                    ProfileView(isMyProfile: false, profileDisplayName: comment.username, profileUserId: comment.userId, posts: PostArrayObject(userID: comment.userId))
                }
            } label: {
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50, alignment: .center)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.CustomColors.vanDyke, lineWidth: 1)
                    )
            }
            .padding(10)
            
            VStack(alignment: .leading, spacing: 4) {
                
                NavigationLink {
                    LazyView {
                        ProfileView(isMyProfile: false, profileDisplayName: comment.username, profileUserId: comment.userId, posts: PostArrayObject(userID: comment.userId))
                    }
                } label: {
                    Text(comment.username)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(comment.content)
                    .padding(.all, 10)
                    .foregroundColor(.primary)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 10)
            
            Spacer(minLength: 0)
        }
        .onAppear {
            getProfileImage()
        }
    }
    
    // MARK: - Methods
    
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: comment.userId) { (returnedImage) in
            if let image = returnedImage {
                self.profilePicture = image
            }
        }
    }
}

struct MessegeView_Previews: PreviewProvider {
    
    static var comment: CommentModel = CommentModel(commentId: "", userId: "", username: "Anton_TravelerUA", content: "This photo is really cool!", dateCreated: Date())
    
    static var previews: some View {
        MessegeView(comment: comment)
            .previewLayout(.sizeThatFits)
    }
}
