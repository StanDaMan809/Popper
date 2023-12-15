//
//  PostsView.swift
//  Popper
//
//  Created by Stanley Grullon on 10/9/23.
//

import SwiftUI

struct PostsView: View {
    @State private var recentsPosts: [Post] = []
    @State private var createNewPost: Bool = false
    
    var body: some View {
        NavigationStack
        {
                ReusablePostsView(posts: $recentsPosts)
            
            // Search Bar
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SearchUserView()
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .tint(.black)
                                .scaleEffect(0.9)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            ConvoList()
                        } label: {
                            Image(systemName: "message.fill")
                                .tint(.black)
                                .scaleEffect(0.9)
                        }
                    }
                })
//                .navigationTitle("Posts")
        }
            .fullScreenCover(isPresented: $createNewPost) {
                CreateNewPost { post in
                    // Adding created post at the top of the recent post
                    recentsPosts.insert(post, at: 0)
                }
            }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
