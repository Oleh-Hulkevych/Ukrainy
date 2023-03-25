//
//  UkrainyView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct UkrainyView: View {
    
    @ObservedObject var post: PostArrayObject
    
    var title: String
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack {
                ForEach(post.postModel, id: \.self) { post in
                    PostView(post: post, showHeaderAndFooter: true, addHeartAnimationToView: true)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UkrainyView(post: PostArrayObject(shuffled: false), title: "Ukrainy")
        }
    }
}

