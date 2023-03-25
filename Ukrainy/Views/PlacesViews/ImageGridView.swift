//
//  ImageGridView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct ImageGridView: View {
    
    @ObservedObject var posts: PostArrayObject
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            alignment: .center,
            spacing: nil,
            pinnedViews: []) {
                ForEach(posts.postModel, id: \.self) { post in
                    NavigationLink {
                        UkrainyView(post: PostArrayObject(post: post), title: "Post")
                    } label: {
                        PostView(post: post, showHeaderAndFooter: false, addHeartAnimationToView: false)
                    }
                }
            }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(posts: PostArrayObject(shuffled: true))
            .previewLayout(.sizeThatFits)
    }
}
