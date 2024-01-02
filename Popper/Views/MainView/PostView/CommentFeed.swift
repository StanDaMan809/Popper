//
//  CommentFeed.swift
//  Popper
//
//  Created by Stanley Grullon on 10/31/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct CommentFeed: View {
    
    var post: Post
    @State private var commentText: String = ""
    
    var onComment: (Comment)->()
    
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
            VStack {
                ReusableCommentView(post: post, comments: post.comments)
                
                VStack {
                    Divider()
                    
                    HStack(alignment: .bottom) {
                        WebImage(url: profileURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .frame(alignment: .bottom)
                        
                        HStack(alignment: .bottom) {
                            TextField("What's happening?", text: $commentText, axis: .vertical)
                                
                                
                            
                            Button {
                                postComment(text: commentText, userUID: userUID)
                                } label: {
                                    Image(systemName: "paperplane.circle.fill")
                                        
                                }
                                .foregroundStyle(Color.pink)
                                .scaleEffect(1.5)
                                
                        }
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .background(
                                RoundedRectangle(cornerRadius: 20) // Adjust the cornerRadius as needed
                                    .stroke(Color.gray, lineWidth: 1) // You can change the color and lineWidth
                            )
                        
                        
                        
        //                .frame(alignment: .top)
                        
                    }
                    .padding()
                }
                
            }
        
        .alert(errorMessage, isPresented: $showError) { }
    }
    
    func postComment(text: String, userUID: String) {
        Task {
            do {
                guard let profileURL = profileURL else { return }
                let textToUpload = text
                
                let comment = Comment(text: textToUpload, userUID: userUID)
                
                try await createDocumentAtFirebase(comment)
                
            } catch {
                
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ comment: Comment)async throws {
        // Writing Document to Firebase Firestore
        guard let postID = post.id else {return}
        let doc = Firestore.firestore().collection("Posts").document(postID).collection("Comments").document()
        
        let _ = try doc.setData(from: comment, completion: { error in
            if error == nil {
                // Post Successfully Stored at Firebase
                var updatedComment = comment
                updatedComment.id = doc.documentID
                onComment(updatedComment)
                
                // Get Rid of Text
                commentText = ""
            }
            
        })
    }
    
    func setError(_ error: Error )async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
        
    }
}
