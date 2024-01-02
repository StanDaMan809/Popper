//
//  Post.swift
//  Popper
//
//  Created by Stanley Grullon on 10/9/23.
//

import SwiftUI
import FirebaseFirestoreSwift

// Post model

struct Post: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var text: String
    var elementsArray: [String : postEnum] = [:]
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
    var comments: [Comment] = []
    var thumbnail: URL

    // Basic User Info
    var userName: String
    var userUID: String
    var userProfileURL: URL
    
    // Post Settings (Visibility, Comments Enabled, Allow Save)
    var visibility: Int // 1: Public, 2: Private (Friends / Followers Only), 3: Me Only
    var commentsEnabled: Bool
    var allowSave: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case elementsArray
        case publishedDate
        case likedIDs
        case dislikedIDs
        case comments
        case thumbnail
        case userName
        case userUID
        case userProfileURL
        case visibility
        case commentsEnabled
        case allowSave
    }
}

enum postEnum: Codable, Equatable, Hashable {
    case image(postImage)
    case video(postVideo)
    case shape(postShape)
    case poll(postPoll)
    case sticker(postSticker)
}


