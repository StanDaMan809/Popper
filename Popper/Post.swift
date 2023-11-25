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
    var elementsArray: [Int : EditableElementData] = [:]
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
    var comments: [Comment] = []

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
        case userName
        case userUID
        case userProfileURL
        case visibility
        case commentsEnabled
        case allowSave
    }
    
}   

struct EditableElementData: Codable, Equatable, Hashable {
    
    let element: ElementType
        
        enum ElementType: Codable, Equatable, Hashable {
            case image(EditableImageData)
            case video(EditableVideoData)
            case shape(EditableShapeData)
            case poll(EditablePollData)
            case sticker(EditableStickerData)
            
            var id: Int {
                switch self {
                case .image(let editableImg):
                    return editableImg.id
                case .video(let editableVid):
                    return editableVid.id
                case .shape(let editableShp):
                    return editableShp.id
                case .poll(let editablePoll):
                    return editablePoll.id
                case .sticker(let editableSticker):
                    return editableSticker.id
                }
            }
        }
        
        static func == (lhs: EditableElementData, rhs: EditableElementData) -> Bool {
            return lhs.element == rhs.element
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(element)
        }
}



