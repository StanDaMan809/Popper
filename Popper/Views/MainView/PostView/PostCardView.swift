//
//  PostCardView.swift
//  Popper
//
//  Created by Stanley Grullon on 10/9/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct PostCardView: View {
    var post: Post
    // Callbacks
    var onUpdate: (Post)->()
    var onDelete: ()->()
    // View Properties
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var docListener: ListenerRegistration?
    @State private var displayComments: Bool = false
    
    var body: some View {
        
            // User information (profile photo, username)
//            ZStack
//            {
//                
//                

                
            VStack(spacing: 0)
                    {
    //                    .vAlign(.top)
                        
                        Divider()
                        
                        HStack(alignment: .top, spacing: 2) {
                            VStack(alignment: .leading){
                                HStack(alignment: .top){
                                    WebImage(url: post.userProfileURL)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 35, height: 35)
                                        .clipShape(Circle())
                                    
                                    Text(post.userName)
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .padding(2)
                                    
                                    Spacer()
                                    
                                   
                                    
                                }
                                
                                Text(post.text)
                                    .font(.callout)
                                    .textSelection(.enabled)
                                    
                            }
                            
                        }
                        .padding()
                        
                        
                        
                        Divider()
                        
                        imgElements(post: post)
                            .clipped()
                            .overlay(
                                HStack {
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        PostInteraction()
                                    }
                                }
                            )
                        
                    }
                    
                    
                
    
//            }
        
                
                .overlay(alignment: .topTrailing, content: {
                    // Displaying delete button, if author
                    if post.userUID == userUID {
                        Menu {
                            Button("Delete Post", role: .destructive, action: deletePost)
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.caption)
                                .rotationEffect(.init(degrees: -90))
                                .foregroundColor(.black)
                                .padding(8)
                                .contentShape(Rectangle())
                        }
                        .offset(x: 8)
                    }
                })
                .onAppear {
                    // adding only once
                    if docListener == nil {
                        guard let postID = post.id else {return}
                        docListener = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot,
                            error in
                            if let snapshot {
                                if snapshot.exists{
                                    // Document Updated
                                    // Fetching Updated Document
                                    if let updatedPost = try? snapshot.data(as: Post.self) {
                                        onUpdate(updatedPost)
                                    }
                                } else {
                                    // Document Deleted
                                    onDelete()
                                }
                            }
                            
                        })
                    }
                
                }
                .onDisappear {
                    // Applying snapshot listener only when the post is available on the screen
                    // Remove the listener (saves unwanted live updates from the posts which was swiped away from the screen)
                    if let docListener{
                        docListener.remove()
                        self.docListener = nil
                    }
            }
            .sheet(isPresented: $displayComments,
                onDismiss: {
                    displayComments = false
                }, content: {
                    NavigationView {
                        CommentFeed(post: post, onComment: { comment in
                            
                        })
                        .navigationTitle("Comments")
                        .navigationBarTitleDisplayMode(.inline)
                        
                            
                    }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
        })
    }
    
    
    // Like / Dislike
    @ViewBuilder
    func PostInteraction()-> some View {
        HStack(alignment: .top, spacing: 6) {
            
            // Like button
            VStack(alignment: .center) {
                Button(action: likePost) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        
                }
                .frame(width: 30, height: 30)
                .foregroundStyle(post.likedIDs.contains(userUID) ? .red : .white)
                
                
                Text("\(post.likedIDs.count)")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            
            // Comment button
            VStack(alignment: .center) {
                Button {
                    displayComments.toggle()
                } label: {
                    Image(systemName: "bubble.right.fill")
                        .resizable()
                        .scaledToFit()
                        
                }
                .frame(width: 30, height: 30)
                .padding(.leading, 5)
                .foregroundStyle(.white)
                
                Text("\(post.comments.count)")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            
            // Share Button
            Button(action: dislikePost) {
                Image(systemName: "arrowshape.turn.up.left.fill")
                    
                    .resizable()
                    .scaledToFit()
                    
            }
            .frame(width: 30, height: 30)
            .padding(.leading, 5)
            .foregroundStyle(.white)
            
        }
        .foregroundColor(.black)
        .padding()
    }
    
    // Like Post
    func likePost() {
        Task {
            guard let postID = post.id else {return}
            if post.likedIDs.contains(userUID) {
                // Removing user ID from array
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID])
                ])
            } else {
                // Add userID to liked Array and removing ID from disliked array
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([userUID]),
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
            }
        }
    }
    
    // Dislike Post
    func dislikePost() {
        Task {
            guard let postID = post.id else {return}
            if post.dislikedIDs.contains(userUID) {
                // Removing user ID from array
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
            } else {
                // Add userID to liked Array and removing ID from disliked array
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID]),
                    "dislikedIDs": FieldValue.arrayUnion([userUID])
                ])
            }
        }
    }
    
    // delete Post
    func deletePost() {
        Task {
            // Delete image from Firebase Storage if present
            do {
//                if post.imageReferenceIDs != "" {
//                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
//                }
                // Delete firestore document
                guard let postID = post.id else {return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}


