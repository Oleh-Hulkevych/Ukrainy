//
//  CommentsView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct CommentsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var submissionText: String = ""
    @State var commentArray = [CommentModel]()
    @State var profilePicture: UIImage = UIImage(named: "user.large.emoji.black")!
    
    var post: PostModel
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [ Color.CustomColors.timberwolf, Color.CustomColors.vanilla,]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                
                ScrollView {
                    LazyVStack {
                        ForEach(commentArray, id: \.self) { comment in
                            MessegeView(comment: comment)
                        }
                    }
                }
                
                HStack {
                    
                    Image(uiImage: profilePicture)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.CustomColors.vanDyke, lineWidth: 1)
                        )
                
                    CustomTextField(
                        placeholder: Text("Add comment here...").foregroundColor(Color.CustomColors.vanDyke),
                        text: $submissionText
                    )
                    
                    Button {
                        if textIsAppropriate() {
                            addComment()
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                    }
                    .accentColor(Color.CustomColors.vanDyke)
                }
                .padding(.all, 10)
            }
            .navigationBarTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(.black)
            .onAppear {
                getComments()
                getProfilePicture()
            }
        }
        
    }
    
    // MARK: - Methods
    
    func getProfilePicture() {
        
        guard let userID = currentUserID else { return }
        
        ImageManager.instance.downloadProfileImage(userID: userID) { (returnedImage) in
            if let image = returnedImage {
                self.profilePicture = image
            }
        }
    }
    
    func getComments() {
        
        guard self.commentArray.isEmpty else { return }
        print("GET COMMENTS FROM DATABASE")
        
        if let caption = post.caption, caption.count > 1 {
            let captionComment = CommentModel(commentId: "", userId: post.userId, username: post.username, content: caption, dateCreated: post.dateCreated)
            self.commentArray.append(captionComment)
        }
        
        DataService.instance.downloadComments(postID: post.postId) { (returnedComments) in
            self.commentArray.append(contentsOf: returnedComments)
        }
    }
    
    func textIsAppropriate() -> Bool {
        
        let badWordArray: [String] = ["shit", "ass", "fuck", "piss off", "bloody hell", "bastard", "motherfucker", "son of a bitch", "asshole", "bollocks"]
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        if submissionText.count < 3 {
            return false
        }
        return true
    }
    
    func addComment() {
        
        guard let userID = currentUserID, let displayName = currentUserDisplayName else { return }
        
        DataService.instance.uploadComment(postID: post.postId, content: submissionText, displayName: displayName, userID: userID) { (success, returnedCommentID) in
            if success, let commentID = returnedCommentID {
                let newComment = CommentModel(commentId: commentID, userId: userID, username: displayName, content: submissionText, dateCreated: Date())
                self.commentArray.append(newComment)
                self.submissionText = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    
    static let post = PostModel(postId: "Test post ID", userId: "Test user ID", username: "Test username", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        NavigationView {
            CommentsView(post: post)
                .preferredColorScheme(.dark)
        }
    }
}


