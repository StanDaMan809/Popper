//
//  profileElement.swift
//  Popper
//
//  Created by Stanley Grullon on 12/7/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct profileElement: Identifiable, Codable, Equatable, Hashable {
    
    static func == (lhs: profileElement, rhs: profileElement) -> Bool {
        return lhs.element == rhs.element
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(element)
    }
    
    @DocumentID var id: String?
    var element: profileElementEnum
    var width: Int // Between 1 and 4, it literally just dictates how many of the views can show up in one line (or maybe between 1 and 5)
    // Cannot have more than 4 size 4s, 3 size 3s, 2 size 2s, 1 size 1 per row.
    var height: Int // Same here, between 1 and 4
    var redirect: redirectEnum
    var pinned: Bool
    var previous: String?
    var next: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case element
        case width
        case height
        case redirect
        case pinned
        case previous
        case next
    }
    
    
}

class profileElementClass: Identifiable, Equatable, ObservableObject {
    static func == (lhs: profileElementClass, rhs: profileElementClass) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String?
    @Published var element: profileElementEnum
    @Published var width: Int // Between 1 and 4, it literally just dictates how many of the views can show up in one line (or maybe between 1 and 5)
    // Cannot have more than 4 size 4s, 3 size 3s, 2 size 2s, 1 size 1 per row.
    @Published var height: Int // Same here, between 1 and 4
    @Published var redirect: redirectEnum
    @Published var pinned: Bool
    @Published var previous: String?
    @Published var next: String?
    
    init(id: String, element: profileElementEnum, width: Int, height: Int, redirect: redirectEnum, pinned: Bool, previous: String? = nil, next: String? = nil) {
        self.id = id
        self.element = element
        self.width = width
        self.height = height
        self.redirect = redirect
        self.pinned = pinned
        self.previous = previous
        self.next = next
    }
    
    init(from element: profileElement) {
        self.id = element.id
        self.element = element.element
        self.width = element.width
        self.height = element.height
        self.redirect = element.redirect
        self.pinned = element.pinned
        self.previous = element.previous
        self.next = element.next
    }
}

enum redirectEnum: Codable, Equatable {
    case post(String)
    case website(String)
    case profile(String)
    
    enum CodingKeys: CodingKey {
        case post
        case website
        case profile
    }
}

enum profileElementEnum: Codable, Equatable, Hashable {
    case image(profileImage)
    case billboard(profileBillboard)
    case poll(profilePoll)
    case shape(profileShape)
    case question(profileQuestion)
    case video(profileVideo)
    
    
    
    enum CodingKeys: CodingKey {
        case image
        case billboard
        case poll
        case shape
        case question
        case video
    }
}


struct profileImage: Codable, Equatable, Hashable {
    var image: URL?
    var offlineImage: UIImage?
    
    enum CodingKeys: CodingKey {
        case image
    }
}

struct profileVideo: Codable, Equatable, Hashable {
    var video: URL
    
    enum CodingKeys: CodingKey {
        case video
    }
}

struct profileShape: Codable, Equatable, Hashable {
    var shape: Int
    var color: [Double]
    
    enum CodingKeys: CodingKey {
        case shape
        case color
    }
}

struct profileText: Codable, Equatable, Hashable {
    var text: String
    var font: String
    var textColor: [Double]
    var bgColor: [Double]
    
    enum CodingKeys: CodingKey {
        case text
        case font
        case textColor
        case bgColor
    }
    
}

struct profileBillboard: Codable, Equatable, Hashable {
    var text: String
    var font: String
    var textColor: [Double]
    var bgColor: [Double]
    
    enum CodingKeys: CodingKey {
        case text
        case font
        case textColor
        case bgColor
    }
}

struct profilePoll: Codable, Equatable, Hashable {
    var question: String?
    var responses: [String]
    var userVotes: [String : Int] // UserUID : Response Clicked
    var topColor: [Double]
    var bgColor: [Double]
    var buttonColor: [Double]
    
    enum CodingKeys: CodingKey {
        case question
        case responses
        case userVotes
        case topColor
        case bgColor
        case buttonColor
    }
}

struct profileQuestion: Codable, Equatable, Hashable {
    var question: String
    var userResponses: [String: String] // UserUID : Response -> this is going to be made a collection
    var txtColor: [Double]
    var bgColor: [Double]
    
    enum CodingKeys: CodingKey {
        case question
        case userResponses
        case txtColor
        case bgColor
    }
}

