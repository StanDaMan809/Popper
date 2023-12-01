//
//  ReusableProfileContent.swift
//  Popper
//
//  Created by Stanley Grullon on 9/30/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ReusableProfileContent: View {
    
    var user: User
    @State private var fetchedPosts: [Post] = []
    @State private var following: Bool = false
    @AppStorage("user_UID") private var userUID: String = ""
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                VStack {
                    HStack(spacing: 12) {
                        WebImage(url: user.userProfileURL).placeholder {
                            Image("NullProfile")
                                .resizable()
                        }
                        .resizable()
                        .hAlign(.leading)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        
                        HStack(spacing: 15) {
                            VStack(alignment: .center) {
                                Text("5") // Placeholder Number
                                    .bold()
                                Text("Following")
                                    .font(.system(size: 15))
                            }
                            
                            VStack(alignment: .center) {
                                Text("1000") // Placeholder Number
                                    .bold()
                                Text("Followers")
                                    .font(.system(size: 15))
                            }
                            
                            VStack(alignment: .center) {
                                Text("1400") // Placeholder Number
                                    .bold()
                                Text("Pops")
                                    .font(.system(size: 15))
                            }
                            
                        }
                        .hAlign(.center)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(user.username)
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .font(.callout)
//                            .font(.system(size: 20))
                        
                        Text(user.userBio)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .font(.callout)
                            .lineLimit(3)
//                            .font(.system(size: 20))
                        
                        // Displaying Bio Link, if given while signing up
                        if let bioLink = URL(string: user.userBioLink) {
                            Link(user.userBioLink, destination: bioLink)
                                .font(.callout)
                                .tint(.blue)
                                .lineLimit(1)
                        }
                    }
                    .hAlign(.leading)
                    
                    HStack {
                        
                        Button {
                            followUser()
                        } label: {
                            Text(following ? "Unfollow" : "Follow")
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                        }
                        .background(Color.pink.opacity(0.95).cornerRadius(10))
                        
                        Button {
                            // follow
                        } label: {
                            Text("Message")
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                        }
                        .background(Color.pink.opacity(0.95).cornerRadius(10))
                    }
                }
                
                Divider()
                
                ReusablePostsView(basedOnUID: true, uid: user.userUID, posts: $fetchedPosts)
            }
            .padding(15)
        }
        .onAppear {
            checkForFollowing()
            print(following)
        }
    }
    
    func checkForFollowing() {
        
        Firestore.firestore().collection("Users").document(userUID).getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                // Handle the error here if needed
            } else if let document = document, document.exists {
                // The document exists, and you can access its data
                if let followingIDs = document["followingIDs"] as? [String], followingIDs.contains(user.userUID) {
                    // The userUIDToCheck is present in the followingIDs array
                    following = true
                    print("User is following")
                    // Handle the case where the user is following
                } else {
                    // The userUIDToCheck is not present in the followingIDs array
                    following = false
                    print("User is not following")
                    // Handle the case where the user is not following
                }
            } else {
                print("Document does not exist")
                // Handle the case where the document doesn't exist
            }
        }
    }
    
    
    
    func followUser() {
        Task {
            
            // guard let userUID = user.id else return
            // if the viewed user's UID is in the user's viewer tab
                // Make them follow them
            
            if following {
                // Removing the seen user's ID from following array
                try await Firestore.firestore().collection("Users").document(userUID).updateData([
                    "followingIDs": FieldValue.arrayRemove([user.userUID])
                ])
                following = false
            } else {
                // Adding the seen user's ID to the following array
                try await Firestore.firestore().collection("Users").document(userUID).updateData([
                    "followingIDs": FieldValue.arrayUnion([user.userUID])
                ])
                following = true
            }
        }
    }
}
