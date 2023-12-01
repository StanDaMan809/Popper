//
//  User.swift
//  Popper
//
//  Created by Stanley Grullon on 9/29/23.
//

import SwiftUI
import FirebaseFirestoreSwift


struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var userBio: String
    var userBioLink: String
    var userUID: String
    var profile: Profile = Profile()
    var userEmail: String
    var userProfileURL: URL
    var followingIDs: [String]
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case userBio
        case userBioLink
        case userUID
        case profile
        case userEmail
        case userProfileURL
        case followingIDs
    }
}

