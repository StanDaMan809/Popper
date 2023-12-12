//
//  profileElement.swift
//  Popper
//
//  Created by Stanley Grullon on 12/7/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import UIKit

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
    var opacity: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case element
        case width
        case height
        case redirect
        case pinned
        case previous
        case next
        case opacity
    }
    
    init(id: String?, element: profileElementEnum, width: Int, height: Int, redirect: redirectEnum, pinned: Bool, previous: String? = nil, next: String? = nil, opacity: Double = 1.0) {
        self.id = id
        self.element = element
        self.width = width
        self.height = height
        self.redirect = redirect
        self.pinned = pinned
        self.previous = previous
        self.next = next
        self.opacity = opacity
    }
    
    init(from element: profileElementClass) {
        self.id = element.id
        switch element.element {
            
        case .image(let image):
            self.element = .image(profileImage(from: image))
        case .billboard(let billboard):
            self.element = .billboard(profileBillboard(from: billboard))
        case .poll(let poll):
            self.element = .poll(profilePoll(from: poll))
        case .shape(let shape):
            self.element = .shape(profileShape(from: shape))
        case .question(let question):
            self.element = .question(profileQuestion(from: question))
        case .video(let video):
            self.element = .video(profileVideo(from: video))
        }
        
        self.width = element.width
        self.height = element.height
        self.redirect = element.redirect
        self.pinned = element.pinned
        self.previous = element.previous
        self.next = element.next
        self.opacity = element.opacity
    }
    
    
}

class profileElementClass: Identifiable, Equatable, ObservableObject {
    static func == (lhs: profileElementClass, rhs: profileElementClass) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String?
    @Published var element: editableProfileElementEnum
    @Published var width: Int // Between 1 and 4, it literally just dictates how many of the views can show up in one line (or maybe between 1 and 5)
    // Cannot have more than 4 size 4s, 3 size 3s, 2 size 2s, 1 size 1 per row.
    @Published var height: Int // Same here, between 1 and 4
    @Published var redirect: redirectEnum
    @Published var pinned: Bool
    @Published var previous: String?
    @Published var next: String?
    @Published var opacity: Double
    var changed: Bool
    
    init(id: String, element: editableProfileElementEnum, width: Int, height: Int, redirect: redirectEnum, pinned: Bool, previous: String? = nil, next: String? = nil, opacity: Double = 1.0, changed: Bool = false) {
        self.id = id
        self.element = element
        self.width = width
        self.height = height
        self.redirect = redirect
        self.pinned = pinned
        self.previous = previous
        self.next = next
        self.opacity = opacity
        self.changed = changed
    }
    
    init(from element: profileElement) {
        self.id = element.id
        switch element.element {
            
        case .image(let image):
            self.element = .image(profileImageClass(from: image))
        case .billboard(let billboard):
            self.element = .billboard(profileBillboardClass(from: billboard))
        case .poll(let poll):
            self.element = .poll(profilePollClass(from: poll))
        case .shape(let shape):
            self.element = .shape(profileShapeClass(from: shape))
        case .question(let question):
            self.element = .question(profileQuestionClass(from: question))
        case .video(let video):
            self.element = .video(profileVideoClass(from: video))
        }
        
        self.width = element.width
        self.height = element.height
        self.redirect = element.redirect
        self.pinned = element.pinned
        self.previous = element.previous
        self.next = element.next
        self.opacity = element.opacity
        self.changed = false
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

enum editableProfileElementEnum {
    case image(profileImageClass)
    case billboard(profileBillboardClass)
    case poll(profilePollClass)
    case shape(profileShapeClass)
    case question(profileQuestionClass)
    case video(profileVideoClass)
}

class profileImageClass: ObservableObject {
    @Published var image: URL?
    @Published var offlineImage: UIImage?
    
    init(from image: profileImage) {
        self.image = image.image
    }
    
    init(image: URL? = nil, offlineImage: UIImage? = nil) {
        self.image = image
        self.offlineImage = offlineImage
    }
}

class profileVideoClass: ObservableObject {
    @Published var video: URL
    
    init(from video: profileVideo) {
        self.video = video.video
    }
    
    init(video: URL) {
        self.video = video
    }
}

class profileShapeClass: ObservableObject {
    @Published var shape: Int
    @Published var color: Color
    
    init(from shape: profileShape) {
        self.shape = shape.shape
        self.color = Color(red: shape.color[0], green: shape.color[1], blue: shape.color[2])
    }
    
    init(shape: Int, color: Color) {
        self.shape = shape
        self.color = color
    }
    
}


class profileBillboardClass: ObservableObject {
    @Published var text: String
    @Published var font: String
    @Published var textColor: Color
    @Published var bgColor: Color
    
    init(from billboard: profileBillboard) {
        self.text = billboard.text
        self.font = billboard.font
        self.textColor = Color(red: billboard.textColor[0], green: billboard.textColor[1], blue: billboard.textColor[2])
        self.bgColor = Color(red: billboard.bgColor[0], green: billboard.bgColor[1], blue: billboard.bgColor[2])
    }
    
    init(text: String, font: String, textColor: Color, bgColor: Color) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.bgColor = bgColor
    }
    
}

class profilePollClass: ObservableObject {
    @Published var question: String?
    @Published var responses: [String]
    @Published var userVotes: [String : Int] // UserUID : Response Clicked
    @Published var topColor: Color
    @Published var bgColor: Color
    @Published var buttonColor: Color
    
    init(from poll: profilePoll) {
        self.question = poll.question
        self.responses = poll.responses
        self.userVotes = poll.userVotes
        self.topColor = Color(red: poll.topColor[0], green: poll.topColor[1], blue: poll.topColor[2])
        self.bgColor = Color(red: poll.bgColor[0], green: poll.bgColor[1], blue: poll.bgColor[2])
        self.buttonColor = Color(red: poll.buttonColor[0], green: poll.buttonColor[1], blue: poll.buttonColor[2])
    }
    
    init(question: String?, responses: [String], userVotes: [String:Int], topColor: Color, bgColor: Color, buttonColor: Color) {
        self.question = question
        self.responses = responses
        self.userVotes = userVotes
        self.topColor = topColor
        self.bgColor = bgColor
        self.buttonColor = buttonColor
    }

}

class profileQuestionClass: ObservableObject {
    @Published var question: String
    @Published var userResponses: [String: String] // UserUID : Response -> this is going to be made a collection
    @Published var txtColor: Color
    @Published var bgColor: Color
    
    init(from question: profileQuestion) {
        self.question = question.question
        self.userResponses = question.userResponses
        self.txtColor = Color(red: question.txtColor[0], green: question.txtColor[1], blue: question.txtColor[2])
        self.bgColor = Color(red: question.bgColor[0], green: question.bgColor[1], blue: question.bgColor[2])
    }
    
    init(question: String, userResponses: [String : String], txtColor: Color, bgColor: Color) {
        self.question = question
        self.userResponses = userResponses
        self.txtColor = txtColor
        self.bgColor = bgColor
    }
}




struct profileImage: Codable, Equatable, Hashable {
    var image: URL?
    
    enum CodingKeys: CodingKey {
        case image
    }
    
    init(from image: profileImageClass) {
        self.image = image.image
    }
    
    init(image: URL?) {
        self.image = image
    }
}

struct profileVideo: Codable, Equatable, Hashable {
    var video: URL
    
    enum CodingKeys: CodingKey {
        case video
    }
    
    init(from video: profileVideoClass) {
        self.video = video.video
    }
    
    init(video: URL) {
        self.video = video
    }
}

struct profileShape: Codable, Equatable, Hashable {
    var shape: Int
    var color: [Double]
    
    enum CodingKeys: CodingKey {
        case shape
        case color
    }
    
    init(shape: Int, color: [Double]) {
        self.shape = shape
        self.color = color
    }
    
    init(from shape: profileShapeClass) {
        self.shape = shape.shape
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        UIColor(shape.color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.color = [red, green, blue]
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
    
    init(text: String, font: String, textColor: [Double], bgColor: [Double]) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.bgColor = bgColor
    }
    
    init(from billboard: profileBillboardClass) {
        self.text = billboard.text
        self.font = billboard.font
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        UIColor(billboard.textColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.textColor = [red, green, blue]
        
        UIColor(billboard.bgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.bgColor = [red, green, blue]
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
    
    init(question: String?, responses: [String], userVotes: [String :Int], topColor: [Double], bgColor: [Double], buttonColor: [Double] ) {
        self.question = question
        self.responses = responses
        self.userVotes = userVotes
        self.topColor = topColor
        self.bgColor = bgColor
        self.buttonColor = buttonColor
    }
    
    init(from poll: profilePollClass) {
        self.question = poll.question
        self.responses = poll.responses
        self.userVotes = poll.userVotes
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        UIColor(poll.topColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.topColor = [red, green, blue]
        
        UIColor(poll.bgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.bgColor = [red, green, blue]
        
        UIColor(poll.buttonColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.buttonColor = [red, green, blue]
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
    
    init(question: String, userResponses: [String: String], txtColor: [Double], bgColor: [Double]) {
        self.question = question
        self.userResponses = userResponses
        self.txtColor = txtColor
        self.bgColor = bgColor
    }
    
    init(from question: profileQuestionClass) {
        self.question = question.question
        self.userResponses = question.userResponses
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        UIColor(question.txtColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.txtColor = [red, green, blue]
        
        UIColor(question.bgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.bgColor = [red, green, blue]
    }
}



