//
//  Constants.swift
//  Ukrainy
//
//  Created by Hulkevych on 17.11.2022.
//

import Foundation

struct DatabaseUserField {
    
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider = "provider"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"
}

struct DatabasePostField {
    
    static let postID = "post_id"
    static let userID = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
    static let likeCount = "like_count"
    static let likedBy = "liked_by"
    static let comments = "comments"
}

struct DatabaseCommentsField {
    
    static let commentID = "comment_id"
    static let displayName = "display_name"
    static let userID = "user_id"
    static let content = "content"
    static let dateCreated = "date_created"
}

struct DatabaseReportsField {
    
    static let content = "content"
    static let postID = "post_id"
    static let dateCreated = "date_created"
}

struct CurrentUserDefaults {
    
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
}

enum SettingsEditTextOption {
    case displayName
    case bio
}
