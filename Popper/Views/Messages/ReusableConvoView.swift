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
    @State var conversation: Conversation?
    let otherUserUID: String
    @State var message: String = ""
    @State var messages: [Message] = []
    @State private var paginationDoc: QueryDocumentSnapshot?
    @State var isFetching: Bool = true
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView(.vertical) {
                if !isFetching || !messages.isEmpty {
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
                    Task {
                        await sendMessage(text: message)
                        message = ""
                    }
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
            conversation = await getConvo(otherUserUID: otherUserUID)
            await fetchMessages()
        }
        .toolbar(content: {
            ToolbarItem {
                Text("Username")
            }
        })
        .toolbar(.hidden, for: .tabBar)
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
                    .frame(maxWidth: 275, alignment: message.senderUID == parent.userUID ? .trailing : .leading)
                
                if message.senderUID != parent.userUID {
                    Spacer()
                }
            }
//            .padding(.horizontal, 5)
            .onAppear {
                // When last post appears, fetching new post (if there)
                if message.id == parent.messages.last?.id && parent.paginationDoc != nil {
                    Task{await parent.fetchMessages()}
                }
                
                if !message.read && message.senderUID != parent.userUID {
//                    set message read = true i just really dont feel like doin det
                }
            }
        }
    }
    
    func fetchMessages()async {
        do {
            var query: Query!
            
            if let conversation = conversation, let convoID = conversation.id {
                if let paginationDoc {
                    query = Firestore.firestore().collection("Conversations").document(convoID).collection("Messages")
                        .order(by: "timestamp", descending: false)
                        .start(afterDocument: paginationDoc)
                        .limit(to: 20)
                } else
                {
                    query = Firestore.firestore().collection("Conversations").document(convoID).collection("Messages")
                        .order(by: "timestamp", descending: false)
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
    
    func getConvo(otherUserUID: String) async -> Conversation? {
        @AppStorage("user_UID") var userUID: String = ""
        
        // Get the conversation where the conversation participants contains the user's UID and the other person's UID
        
        let convoPath = Firestore.firestore().collection("Conversations").document(userUID < otherUserUID ? "\(userUID)\(otherUserUID)" : "\(otherUserUID)\(userUID)") // We want to generate the convo document with each UID in alphabetical order to prevent any more complex algorithmic implementation
        
        
        do {
            let conversation = try await convoPath.getDocument()
            
            if !conversation.exists {
                try convoPath.setData(from: Conversation(id: userUID < otherUserUID ? "\(userUID)\(otherUserUID)" : "\(otherUserUID)\(userUID)", convoUIDs: [userUID, otherUserUID], lastUpdate: Date()))
            }
            
            let conversationToReturn = try conversation.data(as: Conversation.self)
            
            return conversationToReturn
            
        } catch {
            print("Error getting conversation")
            return nil
        }
    }
    
    func sendMessage(text: String)async {
        do {
            if let id = conversation?.id {
                let convoPath = Firestore.firestore().collection("Conversations").document(id).collection("Messages").document()
                try await convoPath.setData(from: Message(text: text, senderUID: userUID, timestamp: Date(), read: false, heart: false))
            }
        } catch {
            print("Error sending message")
        }
    }
    
}
//
//#Preview {
//    ReusableConvoView()
//}
