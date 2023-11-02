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
                
//                .hAlign(.center).vAlign(.top)
//                .overlay(alignment: .bottomTrailing) {
//                    Button {
//                        createNewPost.toggle()
//                    } label: {
//                        Image(systemName: "plus")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                            .padding(13)
//                            .background(.black, in: Circle())
//                    }
//                    .padding(15)
//                }
            
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
