//
//  Comment.swift
//  Popper
//
//  Created by Stanley Grullon on 10/31/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable, Equatable, Hashable {
    
    @DocumentID var id: String?
    var text: String
    var userUID: String
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
//    var image: URL?
    
    
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case userUID
        case publishedDate
        case likedIDs
//        case image
    }
    
}
