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
    @State private var following: Bool = false
    @State private var profileElementsArray: [profileElement] = []
    @State private var profileElementsClassArray: [profileElementClass] = []
    @AppStorage("user_UID") private var userUID: String = ""
    @State var profileEdit: Bool = false
    @State var followersCount: Int = 0
    @State var followingCount: Int = 0
    @State var loading: Bool = true
    @State var selectedElement: profileElementClass?
    @State var displayPost: Bool = false
    @State var postToDisplay: Post?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                if let bgURL = user.profile.background {
                    WebImage(url: bgURL)
                        .resizable()
                }
                
                VStack(spacing: 0) {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            VStack {
                                HStack(spacing: 12) {
                                    WebImage(url: user.userProfileURL).placeholder {
                                        Image("NullProfile")
                                            .resizable()
                                    }
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 75, height: 75)
                                    .clipShape(Circle())
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 15) {
                                        VStack(alignment: .center) {
                                            if !loading {
                                                Text("\(followingCount)")
                                                    .bold()
                                            }
                                            Text("Following")
                                                .font(.system(size: 15))
                                        }
                                        
                                        VStack(alignment: .center) {
                                            if !loading {
                                                Text("\(followersCount)")
                                                    .bold()
                                            }
                                            Text("Followers")
                                                .font(.system(size: 15))
                                        }
                                        
                                        VStack(alignment: .center) {
                                            if !loading {
                                                Text("1400") // Placeholder Number
                                                    .bold()
                                            }
                                            Text("Pops")
                                                .font(.system(size: 15))
                                        }
                                        
                                    }
                                    
                                    Spacer()
                                }
                                
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(user.nickname)
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .font(.callout)
                                    
                                    Text(user.userBio)
                                        .font(.system(size: 15))
                                        .font(.callout)
                                        .lineLimit(3)
                                    
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
                            .padding()
                            .background(colorScheme == .dark ? Color.black : Color.white)
                            
                            if user.profile.background == nil {
                                Divider()
                            }
                                
                            customProfileView(profile: user.profile, displayPost: $displayPost, postToDisplay: $postToDisplay, profileElementsArray: $profileElementsArray, classElementsArray: $profileElementsClassArray, profileEdit: $profileEdit, selectedElement: $selectedElement, userUID: user.userUID)
                        }
                        
                        
                    }
                    
                    if profileEdit {
                        
                        ProfileBar(userUID: userUID, profileElementsArray: $profileElementsArray, classElementsArray: $profileElementsClassArray, selectedElement: $selectedElement)
                        
                        
                    }
                    
                }
                
//                if displayPost {
//                    VStack {
//                        wrappedPostDisplay(postToDisplay: $postToDisplay, displayPost: $displayPost)
//                            
//                        
//                        Spacer()
//                    }
//                    .background(Color.white)
//                    .transition(.slide)
//                }
        }
        }
        .task {
            
            checkForFollowing()
            do {
                followingCount = try await getFollowingCount()
                followersCount = try await getFollowerCount()
            } catch {
                print("Error: \(error)")
            }
            
            
            loading = false
        }
        .toolbar(content: {
            
            if userUID == user.userUID {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ProfileSettings(user: user)
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        profileEdit.toggle()
                    } label: {
                        if profileEdit {
                            Image(systemName: "pencil").foregroundStyle(Color.red)
                        } else {
                            Image(systemName: "pencil").foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        }
                            
                    }
                }
            }
        } )
        
        .toolbar(profileEdit ? .hidden : .visible, for: .tabBar)
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    func checkForFollowing() {
        
        Firestore.firestore().collection("Users").document(user.userUID).collection("Followers").document(userUID).getDocument { document, error in
            
            if let error = error {
                print("Error retrieving following status")
                
            }
            
            if let document = document, document.exists {
                following = true
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
                //                try await Firestore.firestore().collection("Users").document(userUID).updateData([
                //                    "followingIDs": FieldValue.arrayRemove([user.userUID])
                //                ])
                //                following = false
                
                let followersCollectionRef = Firestore.firestore().collection("Users").document(user.userUID).collection("Followers")
                
                // Add a document with the followerUID as the document ID
                followersCollectionRef.document(userUID).delete() { error in
                    if let error = error {
                        print("Error adding follower: \(error)")
                    } else {
                        print("Follower added successfully!")
                        following = false
                        
                        Firestore.firestore().collection("Users").document(userUID).collection("Following").document(user.userUID).delete()
                    }
                }
            } else {
                //                // Adding the seen user's ID to the following array
                //                try await Firestore.firestore().collection("Users").document(userUID).updateData([
                //                    "followingIDs": FieldValue.arrayUnion([user.userUID])
                //                ])
                //                following = true
                
                let followersCollectionRef = Firestore.firestore().collection("Users").document(user.userUID).collection("Followers")
                
                // Add a document with the followerUID as the document ID
                followersCollectionRef.document(userUID).setData(["timestamp": FieldValue.serverTimestamp()]) { error in
                    if let error = error {
                        print("Error adding follower: \(error)")
                    } else {
                        print("Follower added successfully!")
                        following = true
                        
                        Firestore.firestore().collection("Users").document(userUID).collection("Following").document(user.userUID).setData(["timestamp": FieldValue.serverTimestamp()])
                    }
                }
            }
        }
    }
    
    func getFollowerCount() async throws -> Int {
        let snapshot = try await Firestore.firestore().collection("Users").document(user.userUID).collection("Followers").getDocuments()
        
        return snapshot.documents.count
    }
    
    func getFollowingCount() async throws -> Int {
        let snapshot = try await Firestore.firestore().collection("Users").document(user.userUID).collection("Following").getDocuments()
        
        return snapshot.documents.count
    }

}
