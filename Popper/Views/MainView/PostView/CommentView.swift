//
//  CommentView.swift
//  Popper
//
//  Created by Stanley Grullon on 10/31/23.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import Firebase
import FirebaseStorage

struct CommentView: View {
    
    let comment: Comment
    let postID: String
    @State private var isLoading = true
    @State private var profilePhotoURL: URL?
    
    var onUpdate: (Comment)->()
    var onDelete: ()->()
    
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var docListener: ListenerRegistration?
    
    var body: some View {
        if isLoading { // Loads until the profile photo is retrieved
            loadingCommentView()
                .onAppear{
                    retrieveProfilePhoto(comment: comment)
                }
        } else {
                HStack (alignment: .top) {
                    WebImage(url: profilePhotoURL).placeholder(Image("NullProfile"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    VStack (alignment: .leading) {
                        Text("Username")
                            .fontWeight(.bold)
                            .font(.caption)
                        
                        HStack {
                            Text(comment.text)
                                .font(.caption)
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "heart")
                                    
                            }
                            
                            .padding(.horizontal)
//                            .foregroundStyle(Color(.black))
                        }
                        
                        Text(comment.publishedDate.timeAgoDisplay())
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                    
                    

                }
                .hAlign(.leading)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
            }
    }
    
    func loadingCommentView() -> some View {
        HStack (alignment: .top) {
            Color.gray
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            VStack (alignment: .leading) {
                Capsule()
                    .foregroundStyle(Color.gray)
                    .frame(width: 150)
                
                HStack {
                    Capsule()
                        .foregroundStyle(Color.gray)
                        .frame(width: 225)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "")
                        
                    }
                    .padding(.horizontal)
                }
            }
        }
        .hAlign(.leading)
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
    }
    
    
    func retrieveProfilePhoto(comment: Comment) {
        
        Firestore.firestore().collection("Users").document(comment.userUID).getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                isLoading = false
//                isLoading = false
                // Handle the error here if needed
            } else if let document = document, document.exists {
                // The document exists, and you can access its data
                if let pfpURL = document["userProfileURL"] as? String {
                    profilePhotoURL = URL(string: pfpURL)
//                    isLoading = false
                    print("PFP Obtained Successfully")
                    isLoading = false
                    // Handle the case where the user is following
                } else {
                    // The userUIDToCheck is not present in the followingIDs array
                    print("PFP Not obtained successfully")
                    isLoading = false
//                    isLoading = false
                    // Handle the case where the user is not following
                }
            } else {
                print("Document does not exist")
                isLoading = false
//                isLoading = false
                // Handle the case where the document doesn't exist
            }
        }
    }
    
//    func retrieveProfilePhoto(comment: Comment, completion: @escaping (URL?) -> Void) {
//        Firestore.firestore().collection("Users").document(comment.userUID).getDocument { document, error in
//            if let error = error {
//                print("Error getting document: \(error)")
//                completion(nil)
//                // Handle the error here if needed
//            } else if let document = document, document.exists {
//                // The document exists, and you can access its data
//                if let profilePhotoURLString = document["userProfileURL"] as? String,
//                   let profilePhotoURL = URL(string: profilePhotoURLString) {
//                    print("PFP Obtained Successfully")
//                    completion(profilePhotoURL)
//                    // Handle the case where the user is following
//                } else {
//                    // The userUIDToCheck is not present in the followingIDs array
//                    print("PFP Not obtained successfully")
//                    completion(nil)
//                    // Handle the case where the user is not following
//                }
//            } else {
//                print("Document does not exist")
//                completion(nil)
//                // Handle the case where the document doesn't exist
//            }
//        }
//    }
}
