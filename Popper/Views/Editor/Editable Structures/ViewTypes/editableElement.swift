//
//  editorElement.swift
//  Popper
//
//  Created by Stanley Grullon on 12/16/23.
//

import SwiftUI

class editableElement: ObservableObject, Identifiable {
    @Published var id: String
    @Published var currentShape: ClippableShape = .roundedrectangle
    @Published var position: CGSize = CGSize.zero
    @Published var size: CGSize // Image's true specs, to not be touched
    @Published var scalar: Double = 1.0
    @Published var transparency: Double = 1.0
    @Published var display: Bool
    @Published var createDisplays: [String] = []
    @Published var disappearDisplays: [String] = []
    @Published var rotationDegrees: Angle = Angle.zero
    @Published var lock: Bool = false
    @Published var linkOnClick: URL?
    @Published var soundOnClick: URL?
    let defaultDisplaySetting: Bool
    
    init(id: String, size: CGSize, defaultDisplaySetting: Bool) {
        self.id = id
        self.display = defaultDisplaySetting
        self.size = size
        self.defaultDisplaySetting = defaultDisplaySetting
    }
    
}

class editorImage: editableElement {
    let imgSrc: UIImage
    
    init(id: String, imgSrc: UIImage, size: CGSize, defaultDisplaySetting: Bool) {
        self.imgSrc = imgSrc
        super.init(id: id, size: size, defaultDisplaySetting: defaultDisplaySetting)
    }
}

class editorVideo: editableElement {
    let videoURL: URL
    
    init(id: String, videoURL: URL, size: CGSize, defaultDisplaySetting: Bool) {
        self.videoURL = videoURL
        super.init(id: id, size: size, defaultDisplaySetting: defaultDisplaySetting)
    }
}

class editorShape: editableElement {
    @Published var color: Color = Color.black
    
    init(id: String, defaultDisplaySetting: Bool) {
        super.init(id: id, size: CGSize(width: 100, height: 100), defaultDisplaySetting: defaultDisplaySetting)
    }

}

class editorText: editableElement { // This will not ever be retrieved in a post!
    @Published var font: Font = Font.custom("BarlowCondensed-Medium", size: defaultTextSize)
    @Published var message: String = "Hold to Edit"
    @Published var color: Color = .black
    @Published var bgColor: Color = .clear
    
    init(id: String, defaultDisplaySetting: Bool) {
        super.init(id: id, size: CGSize(width: 80, height: 80), defaultDisplaySetting: defaultDisplaySetting)
    }
}

class editorSticker: editableElement {
    let sticker: URL
    
    init(id: String, sticker: URL, defaultDisplaySetting: Bool) {
        self.sticker = sticker
        super.init(id: id, size: CGSize(width: 50, height: 50), defaultDisplaySetting: defaultDisplaySetting)
    }
    
}

class editorPoll: editableElement {
    @Published var question: String = ""
    @Published var responses: [String] = ["", "", "", ""]
    @Published var topColor: Color = Color.gray
    @Published var bottomColor: Color = Color.black
    @Published var buttonColor: Color = Color.white
    
    init(id: String, defaultDisplaySetting: Bool) {
        super.init(id: id, size: CGSize(width: 375, height: 400), defaultDisplaySetting: defaultDisplaySetting)
    }
    
}

func elementAdd(image: UIImage? = nil, video: (URL, CGSize)? = nil, text: Bool = false, shape: Bool = false, poll: Bool = false, sticker: URL? = nil, sharedEditNotifier: SharedEditState) -> editableElement? {
    var defaultDisplaySetting = true
    @AppStorage("user_UID") var userUID: String = ""
    let id = "\(userUID)\(Date().timeIntervalSince1970)"
    
    if sharedEditNotifier.editorDisplayed == .photoAppear, let currentElement = sharedEditNotifier.selectedElement {
        currentElement.createDisplays.append(id)
        defaultDisplaySetting = false
    }
    
    if let image = image {
        return editorImage(id: id, imgSrc: image, size: image.size, defaultDisplaySetting: defaultDisplaySetting)
    } else if let video = video {
        return editorVideo(id: id, videoURL: video.0, size: video.1, defaultDisplaySetting: defaultDisplaySetting)
    } else if text {
        return editorText(id: id, defaultDisplaySetting: defaultDisplaySetting)
    } else if shape {
        return editorShape(id: id, defaultDisplaySetting: defaultDisplaySetting)
    } else if poll {
        return editorPoll(id: id, defaultDisplaySetting: defaultDisplaySetting)
    } else if let sticker = sticker {
        return editorSticker(id: id, sticker: sticker, defaultDisplaySetting: defaultDisplaySetting)
    } else {
        return nil
    }
}

func colorComponentsFromColor(_ color: Color) -> [Double] {
    guard let cgColor = UIColor(color).cgColor.components else {
        return [0, 0, 0]
    }
    
    let red = Double(cgColor[0])
    let green = Double(cgColor[1])
    let blue = Double(cgColor[2])
    
    return [red, green, blue]
}

func colorFromComponents(_ components: [Double]) -> Color {
    guard components.count == 3 else {
        return Color.black
    }
    
    return Color(red: components[0], green: components[1], blue: components[2])
}

//func convertToEditorImg(imgSource: UIImage, size: CGSize, sharedEditNotifier: SharedEditState) -> editorImage {
//    var defaultDisplaySetting = true
//    @AppStorage("user_UID") var userUID: String = ""
//    let id = "\(userUID)\(Date().timeIntervalSince1970)"
//    
//    if sharedEditNotifier.editorDisplayed == .photoAppear, let currentElement = sharedEditNotifier.selectedElement {
//        currentElement.createDisplays.append(id)
//        defaultDisplaySetting = false
//    }
//    
//    return editorImage(id: id, imgSrc: imgSource, size: imgSource.size, defaultDisplaySetting: defaultDisplaySetting)
//}

//func imageAdd(imgSource: UIImage, elementsArray: [editorElementsArray], sharedEditNotifier: SharedEditState) {
//    
//    var defaultDisplaySetting = true
//    
//    if sharedEditNotifier.editorDisplayed == .photoAppear {
//        
//        if let currentElement = sharedEditNotifier.selectedElement
//        {
//            defaultDisplaySetting = false // set defaultDisplaySetting to false so the post will upload with display = false
//            currentElement.element.createDisplays.append(elementsArray.objectsCount)
//            print(currentElement.element.createDisplays)
//        }
//        
//    }
//
//    else
//    {
//        
//    }
//    
//    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .image(editableImg(id: elementsArray.objectsCount, imgSrc: imgSource, size: CGSizeMake(imgSource.size.width, imgSource.size.height), defaultDisplaySetting: defaultDisplaySetting)))
//
//    elementsArray.objectsCount += 1 // Increasing the number of objects counted for id purposes
////    sharedEditNotifier.editorDisplayed = .none
//    
//}


