//
//  Profile.swift
//  Popper
//
//  Created by Stanley Grullon on 11/24/23.
//

import SwiftUI
import WrappingHStack
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

struct customProfileView: View {
    var profile: Profile
    @State var profileElementsArray: [profileElement] = []
    let userUID: String
    
    var body: some View {
        
//        ScrollView(.vertical) {
            WrappingHStack(alignment: .center, horizontalSpacing: 5, verticalSpacing: 5, fitContentWidth: true) {
                ForEach(profile.elements) { element in
                    if element.pinned {
                        ProfileElementView(element: element)
                    }
                }
                
                
                
                ForEach(profileElementsArray) { element in
                    if !element.pinned {
                        ProfileElementView(element: element)
                    }
                }
            }
//        }
        
        
        .task {
            
            profileElementsArray = []
            
            await downloadElements(userUID: userUID, sortedElementArray: &profileElementsArray)
        }
    }
    
    func downloadElements(userUID: String, sortedElementArray: inout [profileElement])async {
        
        
        
        let userDocRef = Firestore.firestore().collection("Users").document(userUID)
        let elementsCollectionRef = userDocRef.collection("elements")
        var node: String?
        var presortedElementArray: [profileElement] = []
        
        

        do {
            userDocRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting user document: \(error)")
                    return
                }
                
                guard let document = document, document.exists else {
                    print("User document does not exist")
                    return
                }
                
                if let data = document.data(), let profileHead = data["profile"] as? [String : Any], let head = profileHead["head"] as? String {
                    
                    print(head)
                    node = head
                    
                    
                } else {
                    print("Error retrieving profile.head")
                }
            }
            
            print(node ?? "")
            
            let elementsRef = try await userDocRef.collection("elements").getDocuments()
//
//            while node != nil {
//                elementsRef.document(node!).compactMap { doc -> profileElement }
//            }
            
            let fetchedElements = elementsRef.documents.compactMap { doc -> profileElement? in
                try? doc.data(as: profileElement.self)
                
            }
            
            presortedElementArray.append(contentsOf: fetchedElements)
            
            print(presortedElementArray.count)
            
            
            // Linked list algorithm to generate elements in their proper order 
            
            while node != nil {
                print("get in there,,,, yeahh yeahhh get in there!!!")
                for element in presortedElementArray {
                    if node == element.id {
                        print("hey thereeeee hey there you hey thereeee")
                        sortedElementArray.append(element)
                        node = element.next
                    }
                }
            }
            
            print(sortedElementArray.count)
            
            
            
            // while node != nil
            // var node = profileHead
            // append node to the thing
            // node = node.next else node = nil
            
            
            
        }
         catch {
            print("nerd")
        }
        
        print("andddd we're done")
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

struct Profile: Codable, Equatable, Hashable {
    
    var head: String? 
    var elements: [profileElement] = []
    var background: URL?
    var song: URL?
    
    enum CodingKeys: CodingKey {
        case elements
        case background
        case song
    }
    
}

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
    case question(profileQuestion)
    case video(profileVideo)
    
    enum CodingKeys: CodingKey {
        case image
        case billboard
        case poll
        case question
        case video
    }
}



struct profileImage: Codable, Equatable, Hashable {
    var image: URL
    
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
    var userResponses: [String: String] // UserUID : Response
    
    enum CodingKeys: CodingKey {
        case question
        case userResponses
    }
}

//extension Profile {
//    static func fromArray(_ array: [[String: Any]]) -> [profileElement] {
//        
//        var profileArray: [profileElement] = []
//        
//        for element in array {
//            if let convertedElement = profileElement.fromDictionary(element) {
//                profileArray.append(convertedElement)
//            }
//        }
//        
//        return profileArray
//    }
//}
//
//extension profileElement {
//    
//    func toDictionary() -> [String: Any] {
//        var dictionary: [String: Any] = [:]
//        
//        dictionary["id"] = id
//        dictionary["element"] = element.toDictionary()
//        dictionary["width"] = width
//        dictionary["height"] = height
//        dictionary["redirect"] = redirect.toDictionary()
//        dictionary["pinned"] = pinned
//        
//        return dictionary
//    }
//    
//    static func fromDictionary(_ dictionary: [String: Any]) -> profileElement? {
//        guard
//            let id = dictionary["id"] as? Int,
//            let elementRawValue = dictionary["element"] as? [String: Any],
//            let element = profileElementEnum.fromDictionary(elementRawValue),
//            let width = dictionary["width"] as? Int,
//            let height = dictionary["height"] as? Int,
//            let redirectDictionary = dictionary["redirect"] as? [String: Any],
//            let redirect = redirectEnum.fromDictionary(redirectDictionary),
//            let pinned = dictionary["pinned"] as? Bool
//        else {
//            return nil
//        }
//        
//        return profileElement(id: id, element: element, width: width, height: height, redirect: redirect, pinned: pinned)
//    }
//    
//}
//
//extension profileElementEnum {
//    
//    func toDictionary() -> [String: Any] {
//        switch self {
//        case .image(let value):
//            return ["type": "image", "value": value.toDictionary()]
//        case .billboard(let value):
//            return ["type": "billboard", "value": value.toDictionary()]
//        case .poll(let value):
//            return ["type": "poll", "value": value.toDictionary()]
//        case .question(let value):
//            return ["type": "question", "value": value.toDictionary()]
//        case .video(let value):
//            return ["type": "video", "value": value.toDictionary()]
//        }
//    }
//    
//    static func fromDictionary(_ dictionary: [String: Any]) -> profileElementEnum? {
//        guard
//            let type = dictionary["type"] as? String,
//            let value = dictionary["value"] as? [String: Any]
//        else {
//            return nil
//        }
//
//        switch type {
//        case "image":
//            if let image = profileImage.fromDictionary(value) {
//                return .image(image)
//            }
//        case "billboard":
//            if let billboard = profileBillboard.fromDictionary(value) {
//                return .billboard(billboard)
//            }
//        case "poll":
//            if let poll = profilePoll.fromDictionary(value) {
//                return .poll(poll)
//            }
//        case "question":
//            if let question = profileQuestion.fromDictionary(value) {
//                return .question(question)
//            }
//        case "video":
//            if let video = profileVideo.fromDictionary(value) {
//                return .video(video)
//            }
//        default:
//            return nil
//        }
//
//        return nil
//    }
//    
//}
//extension redirectEnum {
//    
//    func toDictionary() -> [String: Any] {
//        switch self {
//        case .post(let value):
//            return ["type": "post", "value": value]
//        case .website(let value):
//            return ["type": "website", "value": value]
//        case .profile(let value):
//            return ["type": "profile", "value": value]
//        }
//    }
//    
//    static func fromDictionary(_ dictionary: [String: Any]) -> redirectEnum? {
//        guard
//            let type = dictionary["type"] as? String,
//            let value = dictionary["value"] as? String
//        else {
//            return nil
//        }
//        
//        switch type {
//        case "post":
//            return .post(value)
//        case "website":
//            return .website(value)
//        case "profile":
//            return .profile(value)
//        default:
//            return nil
//        }
//    }
//    
//}
//
//extension profileImage {
//    
//    func toDictionary() -> [String: Any] {
//        return ["image": image.absoluteString]
//    }
//    
//    static func fromDictionary(_ dictionary: [String: Any]) -> profileImage? {
//        guard let urlString = dictionary["image"] as? String,
//              let url = URL(string: urlString)
//        else {
//            return nil
//        }
//        
//        return profileImage(image: url)
//    }
//    
//}
//
//extension profileVideo {
//    
//    func toDictionary() -> [String: Any] {
//        return ["video": video.absoluteString]
//    }
//    
//    static func fromDictionary(_ dictionary: [String: Any]) -> profileVideo? {
//        guard let urlString = dictionary["video"] as? String,
//              let url = URL(string: urlString)
//        else {
//            return nil
//        }
//        
//        return profileVideo(video: url)
//    }
//    
//}
//
//extension profileBillboard {
//    
//    func toDictionary() -> [String: Any] {
//        return ["text": text, "font": font, "textColor": textColor, "bgColor": bgColor]
//    }
//    
//    static func fromDictionary(_ dictionary: [String: Any]) -> profileBillboard? {
//        guard
//            let text = dictionary["text"] as? String,
//            let font = dictionary["font"] as? String,
//            let textColor = dictionary["textColor"] as? [Double],
//            let bgColor = dictionary["bgColor"] as? [Double]
//        else {
//            return nil
//        }
//        
//        return profileBillboard(text: text, font: font, textColor: textColor, bgColor: bgColor)
//    }
//    
//}
//
//extension profilePoll {
//    
//    func toDictionary() -> [String: Any] {
//        return ["question": question ?? "",
//                "responses": responses,
//                "userVotes": userVotes,
//                "topColor": topColor,
//                "bgColor": bgColor,
//                "buttonColor": buttonColor]
//    }
//    
//    static func fromDictionary(_ dictionary: [String: Any]) -> profilePoll? {
//        guard
//            let responses = dictionary["responses"] as? [String],
//            let userVotes = dictionary["userVotes"] as? [String: Int],
//            let topColor = dictionary["topColor"] as? [Double],
//            let bgColor = dictionary["bgColor"] as? [Double],
//            let buttonColor = dictionary["buttonColor"] as? [Double]
//        else {
//            return nil
//        }
//        
//        let question = dictionary["question"] as? String
//        
//        return profilePoll(question: question, responses: responses, userVotes: userVotes, topColor: topColor, bgColor: bgColor, buttonColor: buttonColor)
//    }
//    
//}
//
//extension profileQuestion {
//    
//    func toDictionary() -> [String: Any] {
//        return ["question": question, "userResponses": userResponses]
//    }
//    
//    static func fromDictionary(_ dictionary: [String: Any]) -> profileQuestion? {
//        guard
//            let question = dictionary["question"] as? String,
//            let userResponses = dictionary["userResponses"] as? [String: String]
//        else {
//            return nil
//        }
//        
//        return profileQuestion(question: question, userResponses: userResponses)
//    }
//    
//}

//extension User {
//
//    static func getUser(withUID userUID: String) async throws -> User {
//        let userRef = Firestore.firestore().collection("Users").document(userUID)
//        
//        do {
//            let documentSnapshot = try await userRef.getDocument()
//            
//            let document = documentSnapshot
//            
//            guard document.exists else {
//                throw NSError(domain: "User Not Found", code: 404, userInfo: nil)
//            }
//            
//            var user = try document.data(as: User.self)
//            
//            // Download and decode the 'elements' array
//            user.profile.elements = try await user.profile.downloadElements()
//            
//            return user
//        } catch {
//            throw error
//        }
//    }
//}
//
//extension Profile {
//
//    func downloadElements() async throws -> [profileElement] {
//            guard let userID = Auth.auth().currentUser?.uid else {
//                throw NSError(domain: "UserIDNotFound", code: 401, userInfo: nil)
//            }
//
//            let elementsRef = Firestore.firestore().collection("Users").document(userID).collection("profile").document("elements")
//
//            do {
//                let documentSnapshot = try await elementsRef.getDocument()
//                
//                 let document = documentSnapshot
//                
//                guard document.exists else {
//                    return [] // Return an empty array if the document doesn't exist yet
//                }
//                
//                if let data = document.data() {
//                    var elements: [profileElement] = []
//                    
//                    for (_, value) in data {
//                        guard let elementDictionary = value as? [String: Any] else {
//                            continue
//                        }
//                        
//                        if let element = profileElementEnum.fromDictionary(elementDictionary) {
//                            elements.append(profileElement(id: elements.count, element: element, width: 0, height: 0, redirect: .post(""), pinned: false))
//                        }
//                    }
//                    
//                    return elements
//                }
//                
//                return []
//            } catch {
//                throw error
//            }
//        }
//}

