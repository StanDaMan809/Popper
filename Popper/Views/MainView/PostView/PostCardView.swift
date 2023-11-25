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
            ZStack
            {
                
                imgElements(post: post)

                
                VStack
                    {
                        HStack(alignment: .top, spacing: 2) {
                            VStack(alignment: .leading){
                                HStack(alignment: .center){
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
                                    
                                    PostInteraction()
                                }
                                
                                Text(post.text)
                                    .font(.callout)
                                    .textSelection(.enabled)
                                    .padding(.bottom, 5)
                            }
                            
                //            VStack(alignment: .leading, spacing: 6) {

                //                Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                //                    .font(.caption2)
                //                    .foregroundColor(.gray)
                                
            
                //            }
                            
                            
                            
                        }
                        .zIndex(1)
                        .hAlign(.leading)
                        .padding(.horizontal)
    //                    .vAlign(.top)
                        
                        Divider()

                        
                        
                        
                        
                    }
                    .background(.white)
                    .vAlign(.top)
                    
            }
        
                
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
                    Image(systemName: post.likedIDs.contains(userUID) ? "heart.fill" : "heart")
                }
                .foregroundColor(post.likedIDs.contains(userUID) ? .red : .gray)
                
                
                Text("\(post.likedIDs.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Comment button
            VStack(alignment: .center) {
                Button {
                    displayComments.toggle()
                } label: {
                    Image(systemName: "bubble.fill")
                }
                .padding(.leading, 5)
                .foregroundColor(.gray)
                
                Text("\(post.comments.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Share Button
            Button(action: dislikePost) {
                Image(systemName: "arrowshape.turn.up.left.fill")
            }
            .padding(.leading, 5)
            .foregroundColor(.gray)
            
        }
        .hAlign(.trailing)
        .foregroundColor(.black)
        .padding(8)
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


