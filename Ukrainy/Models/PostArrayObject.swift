//
//  PostArrayObject.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import Foundation

class PostArrayObject: ObservableObject {
    
    @Published var postModel = [PostModel]()
    @Published var postCountString = "0"
    @Published var likeCountString = "0"
    
    /// Use for sigle post selection
    init(post: PostModel) {
        self.postModel.append(post)
    }
    
    /// Get post for user profile
    init(userID: String) {
        print("📔: Get posts for user ID: \(userID)")
        DataService.instance.downloadPostForUser(userID: userID) { (returnedPosts) in
            
            let sortedPosts = returnedPosts.sorted { (post1, post2) -> Bool in
                return post1.dateCreated > post2.dateCreated
            }
            self.postModel.append(contentsOf: sortedPosts)
            self.updateCounts()
        }
    }
    
    /// Use for feed
    init(shuffled: Bool) {
        print("📔: Get posts for feed. Shuffled: \(shuffled)")
        DataService.instance.downloadPostsForFeed { (returnedPosts) in
            if shuffled {
                let shuffledPosts = returnedPosts.shuffled()
                self.postModel.append(contentsOf: shuffledPosts)
            } else {
                self.postModel.append(contentsOf: returnedPosts)
            }
        }
    }
    
    func updateCounts() {
        self.postCountString = "\(self.postModel.count)"
        let likeCountArray = postModel.map { (existingPost) -> Int in
            return existingPost.likeCount
        }
        let sumOfLikeCountArray = likeCountArray.reduce(0, +)
        self.likeCountString = "\(sumOfLikeCountArray)"
    }
}
