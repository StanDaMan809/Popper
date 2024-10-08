//
//  ReusablePostsView.swift
//  Popper
//
//  Created by Stanley Grullon on 10/9/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct ReusablePostsView: View {
    var basedOnUID: Bool = false
    var uid: String = ""
    @Binding var posts: [Post]
    // View Properties
    @State private var isFetching: Bool = true
    @State private var displayedPostIndex: Int = 0
    // pagination
    @State private var paginationDoc: QueryDocumentSnapshot?
    @GestureState private var dragState: CGFloat = 0
    
    
    var body: some View {
        ScrollView(.vertical)
        {
            LazyVStack {
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if posts.isEmpty {
                        // No Posts found on Firestore
                        Text("No Posts Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        // Displaying posts
                        Posts()
                        
                        
                    }
                    
                }
            }
        }
        //            .rotationEffect(Angle(degrees: 90))
        
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        
        
        
        
        .refreshable {
            guard !basedOnUID else {return}
            isFetching = true
            posts = []
            // Resetting Pagination Doc
            paginationDoc = nil
            await fetchPosts()
        }
        .task {
            guard posts.isEmpty else{return}
            await fetchPosts()
        }
        
        //        }
        
    }
    
    // Displaying fetched posts
    @ViewBuilder
    func Posts() -> some View {
        
        //        if #available(iOS 17.0, *) {
        //                        LazyVStack {
        //                            ForEach(posts) { post in
        //                                PostCardView(post: post) { updatedPost in
        //                                    // Updating Post in the array
        //                                    if let index = posts.firstIndex(where: { post in
        //                                        post.id == updatedPost.id
        //
        //                                    })
        //                                    {
        //                                        posts[index].likedIDs = updatedPost.likedIDs
        //                                        posts[index].dislikedIDs = updatedPost.dislikedIDs
        //                                    }
        //
        //
        //
        //                                } onDelete: {
        //                                    // Removing post from the array
        //                                    withAnimation(.easeInOut(duration: 0.25)){
        //                                        posts.removeAll{post.id == $0.id}
        //                                    }
        //                                }
        //
        //                                .onAppear {
        //                                    // When last post appears, fetching new post (if there)
        //                                    if post.id == posts.last?.id && paginationDoc != nil {
        //                                        Task{await fetchPosts()}
        //                                    }
        //                                }
        //
        //
        //
        //
        //                        }
        //                        }
        //                        .scrollTargetLayout()
        //
        //
        //
        //
        //        } else {
        ForEach(posts) { post in
            PostCardView(post: post) { updatedPost in
                // Updating Post in the array
                if let index = posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                    
                })
                {
                    posts[index].likedIDs = updatedPost.likedIDs
                    posts[index].dislikedIDs = updatedPost.dislikedIDs
                }
                
                
                
            } onDelete: {
                // Removing post from the array
                withAnimation(.easeInOut(duration: 0.25)){
                    posts.removeAll{post.id == $0.id}
                }
            }
            
            //                .rotationEffect(Angle(degrees: -90))
            
            .onAppear {
                // When last post appears, fetching new post (if there)
                if post.id == posts.last?.id && paginationDoc != nil {
                    Task{await fetchPosts()}
                }
            }
            
            
            
            
            
        }
        //        }
        
        //            Divider()
        //                .padding(.horizontal, -15)
    }
    
    // Fetching posts
    func fetchPosts()async {
        do {
            var query: Query!
            // Implementing pagination
            
            if let paginationDoc {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 10)
            } else
            {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 10)
            }
            
            // New Query for UID based document fetch
            if basedOnUID{
                query = query
                    .whereField("userUID", isEqualTo: uid)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
                
            }
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFetching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}
