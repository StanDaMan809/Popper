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
    var txtArray: [EditableTextData] = [] // Added
    var imagesArray: [EditableImageData] = [] // Added
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
    var comments: [Comment] = []

    // Basic User Info
    var userName: String
    var userUID: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case txtArray
        case imagesArray
        case publishedDate
        case likedIDs
        case dislikedIDs
        case comments
        case userName
        case userUID
        case userProfileURL
    }
    
}   


