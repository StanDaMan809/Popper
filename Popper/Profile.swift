//
//  Profile.swift
//  Popper
//
//  Created by Stanley Grullon on 11/24/23.
//

import SwiftUI
import WrappingHStack
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

struct profileView: View {
    var profile: Profile
    
    var body: some View {
        
        ScrollView(.vertical) {
            WrappingHStack(alignment: .center, horizontalSpacing: 5, verticalSpacing: 5, fitContentWidth: true) {
                ForEach(profile.elements) { element in
                    ProfileElementView(element: element)
                }
                
                ForEach(profile.elements) { element in
                    if !element.pinned {
                        ProfileElementView(element: element)
                    }
                }
            }
        }
    }
}


func sizeify(element: profileElement) -> CGSize {
    
    let spacingWidth: CGFloat = 5.0
    var width: CGFloat = UIScreen.main.bounds.width - (spacingWidth * 2)
    var height: CGFloat = UIScreen.main.bounds.width - (spacingWidth * 2)
    
    // THESE FORMULAS WERE GEOMETRICALLY CALCULATED, OKAY! IM A WIZ!!
    
    switch element.width {
    case 1:
        width = UIScreen.main.bounds.width - (spacingWidth * 2) // Whole row
    case 2:
        width = (UIScreen.main.bounds.width - (spacingWidth * 3)) / 2 // Takes up 1/2 of the row
    case 3:
        width = (UIScreen.main.bounds.width - (spacingWidth * 4)) / 3 // Takes up 1/3rd of the row
    case 4:
        width = (UIScreen.main.bounds.width - (spacingWidth * 5)) / 4 // Takes up 1/4rd of the row
    case 5:
        width = (UIScreen.main.bounds.width - (spacingWidth * 6)) / 5 // Takes up 1/5 of the row
    case 6:
        width = UIScreen.main.bounds.width - (spacingWidth * 3) - (UIScreen.main.bounds.width - (spacingWidth * 5) / 4) // Takes up three-quarters of the row, meant to fit with a size four
    case 7:
        width = UIScreen.main.bounds.width - (spacingWidth * 4) - 2 * ((UIScreen.main.bounds.width - (spacingWidth * 6)) / 5) // Takes up 4/5 of the row, meant to fit with a size five
    default:
        width = UIScreen.main.bounds.width - (spacingWidth * 2)
    }
    
    switch element.height {
    case 1:
        height = UIScreen.main.bounds.width - (spacingWidth * 2)
    case 2:
        height = (UIScreen.main.bounds.width - (spacingWidth * 3)) / 2
    case 3:
        height = (UIScreen.main.bounds.width - (spacingWidth * 4)) / 3
    case 4:
        height = (UIScreen.main.bounds.width - (spacingWidth * 5)) / 4
    case 5:
        height = (UIScreen.main.bounds.width - (spacingWidth * 6)) / 5
    case 6:
        height = UIScreen.main.bounds.width - (spacingWidth * 3) - (UIScreen.main.bounds.width - (spacingWidth * 5) / 4)
    case 7:
        height = UIScreen.main.bounds.width - (spacingWidth * 4) - 2 * ((UIScreen.main.bounds.width - (spacingWidth * 6)) / 5)
    default:
        height = UIScreen.main.bounds.width - (spacingWidth * 2)
    }
    
    return CGSize(width: width, height: height)
    
    
}

struct Profile: Codable {
    
    var elements: [profileElement] = []
    var background: URL?
    var song: URL?
    
    enum CodingKeys: CodingKey {
        case elements
        case background
        case song
    }
    
}

struct profileElement: Identifiable, Codable {
    
    var id: Int
    var element: profileElementEnum
    var width: Int // Between 1 and 4, it literally just dictates how many of the views can show up in one line (or maybe between 1 and 5)
    // Cannot have more than 4 size 4s, 3 size 3s, 2 size 2s, 1 size 1 per row.
    var height: Int // Same here, between 1 and 4
    var redirect: redirectEnum
    var pinned: Bool
    
    
    
}

enum redirectEnum: Codable {
    case post(String)
    case website(String)
    case profile(String)
}

enum profileElementEnum: Codable {
    case image(profileImage)
    case billboard(profileBillboard)
    case poll(profilePoll)
    case question(profileQuestion)
    case video(profileVideo)
}

struct profileImage: Codable {
    var image: URL
}

struct profileVideo: Codable {
    var video: URL
}

struct profileText: Codable {
    var text: String
    var font: String
    var textColor: [Int]
    var bgColor: [Int]
    
}

struct profileBillboard: Codable {
    var text: String
    var font: String
    var textColor: [Double]
    var bgColor: [Double]
}

struct profilePoll: Codable {
    var question: String?
    var responses: [String]
    var userVotes: [String : Int] // UserUID : Response Clicked
    var topColor: [Double]
    var bgColor: [Double]
    var buttonColor: [Double]
}

struct profileQuestion: Codable {
    var question: String
    var userResponses: [String: String] // UserUID : Response
}


