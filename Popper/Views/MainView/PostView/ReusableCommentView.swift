//
//  ReusableCommentView.swift
//  Popper
//
//  Created by Stanley Grullon on 10/31/23.
//

import SwiftUI
import Firebase

struct ReusableCommentView: View {
    
    var post: Post
    @State var comments: [Comment]
    @State private var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if comments.isEmpty {
                        // No Posts found on Firestore
                        Text("No Comments Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        // Displaying comments
                            Comments()

                    }
                }
            }
        }
        .task {
            guard comments.isEmpty else{return}
            await fetchComments()
        }
        .navigationTitle("5 Comments")
    }
    
    @ViewBuilder
    func Comments() -> some View {
        
        if let postid = post.id {
                ForEach(comments) { comment in
                    
                    CommentView(comment: comment, postID: postid) { updatedComment in
                            // Updating Comments in the array
                            if let index = comments.firstIndex(where: { comment in
                                comment.id == updatedComment.id
                                
                            })
                            {
                                comments[index].likedIDs = updatedComment.likedIDs
                            }
                        } onDelete: {
                            // Removing comment from the array
                            withAnimation(.easeInOut(duration: 0.25)){
                                comments.removeAll{comment.id == $0.id}
                            }
                        }
                        
                        .onAppear {
                            // When last post appears, fetching new post (if there)
                            if comment.id == comments.last?.id && paginationDoc != nil {
                                Task{await fetchComments()}
    
                            }
                        }
                }
            }
    }
    
    func fetchComments()async {
        do {
            var query: Query!
            // Implementing pagination
            
            
            
            // Change this to just loading the comments from the post thing itself.
            
            if let postID = post.id {
                if let paginationDoc {
                    query = Firestore.firestore().collection("Posts").document(postID).collection("Comments")
                        .order(by: "publishedDate", descending: true)
                        .start(afterDocument: paginationDoc)
                        .limit(to: 10)
                } else
                {
                    query = Firestore.firestore().collection("Posts").document(postID).collection("Comments")
                        .order(by: "publishedDate", descending: true)
                        .limit(to: 10)
                }
                
                let docs = try await query.getDocuments()
                let fetchedComments = docs.documents.compactMap { doc -> Comment? in
                    try? doc.data(as: Comment.self)
                    
                }
                await MainActor.run(body: {
                    comments.append(contentsOf: fetchedComments)
                    paginationDoc = docs.documents.last
                    isFetching = false
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func retrieveProfilePhoto(comment: Comment)async -> URL? {
//
//        guard let doc = try? await Firestore.firestore().collection("Users").document(comment.userUID).getDocument() else { return URL(string: "")}
//        if doc.exists, let pfpURL = doc["userProfileURL"] as? String {
//            profilePhotoURL = URL(string: pfpURL)
//            return profilePhotoURL
//        }
//    }
                
//        if let Firestore.firestore().collection("Users").document(comment.userUID).getDocument { document, error in
//            if let error = error {
//                print("Error getting document: \(error)")
//                // Handle the error here if needed
//            } else if let document = document, document.exists {
//                // The document exists, and you can access its data
//                if let pfpURL = document["userProfileURL"] as? String {
//                    profilePhotoURL = URL(string: pfpURL)
//                    print("PFP Obtained Successfully")
//                    // Handle the case where the user is following
//                } else {
//                    // The userUIDToCheck is not present in the followingIDs array
//                    print("PFP Not obtained successfully")
//                    // Handle the case where the user is not following
//                }
//            } else {
//                print("Document does not exist")
//                // Handle the case where the document doesn't exist
//            }
//        }
    
}

//#Preview {
//    ReusableCommentView()
//}
