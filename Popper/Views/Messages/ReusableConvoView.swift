//
//  ReusableConvoView.swift
//  Popper
//
//  Created by Stanley Grullon on 12/14/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ReusableConvoView: View {
    let conversation: Conversation
    @State var message: String = ""
    @State var messages: [Message] = []
    @State private var paginationDoc: QueryDocumentSnapshot?
    @State var isFetching: Bool = true
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "chevron.backward")
                }
                
                Spacer()
                
                Text("Username")
                    .fontWeight(.heavy)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "chevron.backward")
                }
                .opacity(0)
            }
            .padding()
            
            Divider()
            
            ScrollView(.vertical) {
                if !isFetching || messages.isEmpty {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(messages) { message in
                            MessageBubble(parent: self, message: message)
                        }
                    }
                    .padding()
                } else {
                    ProgressView()
                }
            }
            
            Spacer()
            
            HStack {
                
                if message == "" {
                    Button {
                        
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color.blue)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "plus")
                                .foregroundStyle(Color.white)
                            
                        }
                    }
                }
                
                
                
                TextField("Your Message", text: $message, axis: .vertical)
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(Color.gray))
                
                Button {
                    
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.pink)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(Color.white)
                    }
                }
                
            }
            .padding()
        }
        .onAppear {
            // Download the other user's pfp and store it as an image
        }
        .task {
            guard messages.isEmpty else{return}
            await fetchMessages()
        }
    }
    
    struct MessageBubble: View {
        let parent: ReusableConvoView
        let message: Message
        
        var body: some View {
            
            HStack {
                
                if message.senderUID == parent.userUID {
                    Spacer()
                }
                
                Text(message.text)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .foregroundStyle(Color.white)
                    .background(RoundedRectangle(cornerRadius: 25).foregroundStyle(message.senderUID == parent.userUID ? Color.blue : Color.gray))
                    .frame(maxWidth: 275, alignment: .leading)
                
                if message.senderUID != parent.userUID {
                    Spacer()
                }
            }
            .padding(.horizontal)
            .onAppear {
                // When last post appears, fetching new post (if there)
                if message.id == parent.messages.last?.id && parent.paginationDoc != nil {
                    Task{await parent.fetchMessages()}
                }
            }
        }
    }
        
        func fetchMessages()async {
            do {
                var query: Query!
                // Implementing pagination
                
                // Change this to just loading the comments from the post thing itself.
                
                if let convoID = conversation.id {
                    if let paginationDoc {
                        query = Firestore.firestore().collection("Conversations").document(convoID).collection("Messages")
                            .order(by: "timestamp", descending: true)
                            .start(afterDocument: paginationDoc)
                            .limit(to: 20)
                    } else
                    {
                        query = Firestore.firestore().collection("Conversations").document(convoID).collection("Messages")
                            .order(by: "timestamp", descending: true)
                            .limit(to: 20)
                    }
                    
                    let docs = try await query.getDocuments()
                    let fetchedMessages = docs.documents.compactMap { doc -> Message? in
                        try? doc.data(as: Message.self)
                        
                    }
                    await MainActor.run(body: {
                        messages.append(contentsOf: fetchedMessages)
                        paginationDoc = docs.documents.last
                        isFetching = false
                    })
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    
}
//
//#Preview {
//    ReusableConvoView()
//}
