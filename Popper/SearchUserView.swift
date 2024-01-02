//
//  SearchUserView.swift
//  Popper
//
//  Created by Stanley Grullon on 10/9/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SearchUserView: View {
    
    var displayProfileOnClick: Bool = true
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @State private var conversation: Conversation?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(fetchedUsers) { user in
                    NavigationLink {
                        if displayProfileOnClick{
                            ReusableProfileContent(user: user)
                        } else {
                            ReusableConvoView(otherUserUID: user.userUID)
                        }
                    } label: {
                        Text(user.username)
                            .font(.callout)
                            .hAlign(.leading)
                    }
                    .id(UUID())
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        //            .navigationTitle("Search Users")
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            // Fetch users from firebase
            Task{await searchUsers()}
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty{
                fetchedUsers = []
            }
            
        })
    }
    func searchUsers()async {
        do {
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searchText)
                .whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
                
            }
            // UI Must be updated on main thread
            await MainActor.run(body: {
                fetchedUsers = users
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
 
}
