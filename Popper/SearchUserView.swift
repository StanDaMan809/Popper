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
    
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            ScrollView { // If I keep it as a list, it crashes regardless
                ForEach(fetchedUsers) { user in
                    NavigationLink {
                        ReusableProfileContent(user: user)
                    } label: {
                        Text(user.username)
                            .font(.callout)
                            .hAlign(.leading)
                    }
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
