//
//  PostView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct PostView: View {
    
    @State var post: PostModel
    var showHeaderAndFooter: Bool
    
    @State var animateLike: Bool = false
    @State var addHeartAnimationToView: Bool
    
    @State var showActionSheet: Bool = false
    @State var actionSheetType: PostActionSheetOption = .general
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var postImage: UIImage = UIImage(named: "logo.loading")!
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    enum PostActionSheetOption {
        case general
        case report
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {

            if showHeaderAndFooter {
                HStack {
                    NavigationLink {
                        LazyView {
                            ProfileView(isMyProfile: false, profileDisplayName: post.username, profileUserId: post.userId, posts: PostArrayObject(userID: post.userId))
                        }
                    } label: {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30, alignment: .center)
                            .cornerRadius(15)
                        Text(post.username)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    Spacer()

                    Button {
                        showActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.headline)
                    }
                    .tint(.primary)
                    .actionSheet(isPresented: $showActionSheet) {
                        getActionSheet()
                    }
                }
                .padding(.all, 10)
            }

            ZStack {
                Image(uiImage: postImage)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture(count: 2) {
                        if !post.likedByUser {
                            likePost()
                            AnalyticsService.instance.likePostDoubleTap()
                        }
                    }
                
                if addHeartAnimationToView {
                    LikeAnimationView(animate: $animateLike)
                }
            }

            if showHeaderAndFooter {
                HStack(alignment: .center, spacing: 20) {
                    Button {
                        if post.likedByUser {
                            unlikePost()
                        } else {
                            likePost()
                            AnalyticsService.instance.likePostHeartPressed()
                        }
                    } label: {
                        Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                    }
                    .tint(post.likedByUser ? .red : .primary)
                    
                    NavigationLink {
                        CommentsView(post: post)
                    } label: {
                        Image(systemName: "bubble.middle.bottom")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    
                    Button {
                        sharePost()
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.title3)
                    }
                    .tint(.primary)
                    
                    Spacer()
                }
                .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                
                if let caption = post.caption {
                    HStack {
                        Text(caption)
                        Spacer(minLength: 0)
                        
                    }
                    .padding(.init(top: 0, leading: 10, bottom: 10, trailing: 10))
                }
            }
        }
        .onAppear {
            getImages()
        }
        .alert(isPresented: $showAlert) {
            return Alert(title: Text(alertTitle),
                         message: Text(alertMessage),
                         dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - Methods
    
    func likePost() {
        
        guard let userID = currentUserID else {
            print("Cannot find userID while liking post")
            return
        }
        
        let likedPost = PostModel(
            postId: post.postId,
            userId: post.userId,
            username: post.username,
            caption: post.caption,
            dateCreated: post.dateCreated,
            likeCount: post.likeCount + 1,
            likedByUser: true
        )
        self.post = likedPost
        animateLike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            animateLike = false
        }
        
        DataService.instance.likePost(postID: post.postId, currentUserID: userID)
    }
    
    func unlikePost() {
        
        guard let userID = currentUserID else {
            print("Cannot find userID while unliking post")
            return
        }
        
        let updatedPost = PostModel(postId: post.postId, userId: post.userId, username: post.username, caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount - 1, likedByUser: false)
        self.post = updatedPost
        
        DataService.instance.unlikePost(postID: post.postId, currentUserID: userID)
    }
    
    func getImages() {
        
        ImageManager.instance.downloadProfileImage(userID: post.userId) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
        
        ImageManager.instance.downloadPostImage(postID: post.postId) { (returnedImage) in
            if let image = returnedImage {
                self.postImage = image
            }
        }
    }
    
    func getActionSheet() -> ActionSheet {
        
        switch self.actionSheetType {
        case .general:
            return ActionSheet(title: Text("What would you like to do?"), message: nil, buttons: [
                .destructive(Text("Report"), action: {
                    self.actionSheetType = .report
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showActionSheet.toggle()
                    }
                }),
                .default(Text("Learn more.."), action: {
                    print("LEARN MORE PRESSED")
                }),
                .cancel()
            ])
        case .report:
            return ActionSheet(title: Text("Why are you reporting this post?"), message: nil, buttons: [
                .destructive(Text("This is inappropriate"), action: {
                    reportPost(reason: "This is inappropriate")
                }),
                .destructive(Text("This is spam"), action: {
                    reportPost(reason: "This is spame")
                }),
                .destructive(Text("It made me uncomfortable"), action: {
                    reportPost(reason: "It made me uncomfortable")
                }),
                .cancel({
                    self.actionSheetType = .general
                })
            ])
        }
    }
    
    func reportPost(reason: String) {
        print("REPORT POST NOW")
        
        DataService.instance.uploadReport(reason: reason, postID: post.postId) { (success) in
            if success {
                self.alertTitle = "Reported!"
                self.alertMessage = "Thanks for reporting this post.\nWe will review it and take the appropriate action!"
                self.showAlert.toggle()
            } else {
                self.alertTitle = "Error"
                self.alertMessage = "There was an error uploading the report.\nPlease restart the app and try again."
                self.showAlert.toggle()
            }
        }
    }
    
    
    func sharePost() {
        
        let message = "Check out this post on Ukrainy app!"
        let image = postImage
        let link = URL(string: "https://github.com/Oleh-Hulkevych")!
        let activityViewController = UIActivityViewController(activityItems: [message, image, link], applicationActivities: nil)
        
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = firstScene.windows.first else { return }
        let viewController = firstWindow.rootViewController
        viewController?.present(activityViewController, animated: true)
    }
}

struct PostView_Previews: PreviewProvider {
    
    static var post: PostModel = PostModel(postId: "", userId: "", username: "Oleksandr", caption: "The description will be here... Very very big description will be here... Bla-bla-bla... Testing.....", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true, addHeartAnimationToView: true)
            .previewLayout(.sizeThatFits)
    }
}
