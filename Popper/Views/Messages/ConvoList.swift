//
//  MessageOverview.swift
//  Popper
//
//  Created by Stanley Grullon on 12/14/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct ConvoList: View {
    
    @State var conversations: [Conversation] = []
    @State var isFetching: Bool = true
    @State private var convoToDisplay: Conversation?
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    var body: some View {
        VStack {
            
            ScrollView(.vertical) {
                ForEach(conversations) { conversation in
                    NavigationLink {
                        ReusableConvoView(conversation: conversation, otherUserUID: conversation.convoUIDs.filter( {$0 != userUID })[0])
                    } label: {
                        convoDisplay(conversation: conversation, otherUserUID: conversation.convoUIDs.filter( {$0 != userUID })[0])
                    }
                }
                
            }
            
            Spacer()
        }
        .task {
            await fetchConvos()
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SearchUserView(displayProfileOnClick: false)
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        })
    }
    
    struct convoDisplay: View {
        @State private var profilePhotoURL: URL?
        @State private var nickname: String?
        @State private var isLoading: Bool = true
        let conversation: Conversation
        let otherUserUID: String
        
        
        var body: some View {
            Group {
                if !isLoading {
                    HStack {
                        
                        WebImage(url: profilePhotoURL).placeholder(Image(systemName: "NullProfile"))
                            .backgroundStyle(Color.gray)
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text(nickname ?? "User")
                            
                            if let lastMessage = conversation.lastMessage {
                                HStack {
                                    Text(lastMessage)
                                        
                                    Text("·")
                                    
                                    Text("5j")
                                }
                                .foregroundStyle(Color.gray)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .onAppear {
                retrieveProfilePhoto(userUID: otherUserUID)
            }
            
        }
        
        func retrieveProfilePhoto(userUID: String) {
            
            Firestore.firestore().collection("Users").document(userUID).getDocument { document, error in
                if let error = error {
                    print("Error getting document: \(error)")
                    isLoading = false
    //                isLoading = false
                    // Handle the error here if needed
                } else if let document = document, document.exists {
                    // The document exists, and you can access its data
                    if let pfpURL = document["userProfileURL"] as? String, let name = document["nickname"] as? String {
                        profilePhotoURL = URL(string: pfpURL)
                        nickname = name
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
    }
    
    func fetchConvos()async {
        do {
            var query: Query!
            // Implementing pagination
            
            // Change this to just loading the comments from the post thing itself.
                if let paginationDoc {
                    query = Firestore.firestore().collection("Conversations").whereField("convoUIDs", arrayContains: userUID)
                        .order(by: "lastUpdate", descending: true)
                        .start(afterDocument: paginationDoc)
                        .limit(to: 20)
                } else
                {
                    query = Firestore.firestore().collection("Conversations").whereField("convoUIDs", arrayContains: userUID)
                        .order(by: "lastUpdate", descending: true)
                        .limit(to: 20)
                }
                
                let docs = try await query.getDocuments()
                let fetchedConvos = docs.documents.compactMap { doc -> Conversation? in
                    try? doc.data(as: Conversation.self)
                    
                }
                await MainActor.run(body: {
                    conversations.append(contentsOf: fetchedConvos)
                    paginationDoc = docs.documents.last
                    isFetching = false
                })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    

    
}

#Preview {
    ConvoList()
}
