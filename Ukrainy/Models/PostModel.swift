//
//  PostModel.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct PostModel: Identifiable, Hashable {
    
    var id = UUID()
    var postId: String
    var userId: String
    var username: String
    var caption: String?
    var dateCreated: Date
    var likeCount: Int
    var likedByUser: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
