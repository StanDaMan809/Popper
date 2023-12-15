//
//  Message.swift
//  Popper
//
//  Created by Stanley Grullon on 12/1/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Conversation: Identifiable, Codable {
    @DocumentID var id: String?
    var convoUIDs: [String] // Allows for easy group chat implementation
    var lastUpdate: Date
    var lastMessage: String?
}

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var senderUID: String
    var timestamp: Date
    var read: Bool
    var heart: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case senderUID
        case timestamp
        case read
        case heart
    }
}
