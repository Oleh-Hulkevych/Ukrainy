//
//  CommentModel.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct CommentModel: Identifiable, Hashable {
    
    var id = UUID()
    var commentId: String
    var userId: String
    var username: String
    var content: String
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
