//
//  postElements.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI

class postElement: ObservableObject, Codable, Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    
    static func == (lhs: postElement, rhs: postElement) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let currentShape: ClippableShape
    let position: CGSize
    let size: CGSize // Image's true specs, to not be touched
    let scalar: Double
    let transparency: Double
    @Published var display: Bool
    let createDisplays: [String]
    let disappearDisplays: [String]
    let rotationDegrees: Angle
    let linkOnClick: URL?
    let soundOnClick: URL?
    let defaultDisplaySetting: Bool
    
    init(from element: editableElement) {
        self.id = element.id
        self.currentShape = element.currentShape
        self.position = element.position
        self.size = element.size
        self.scalar = element.scalar
        self.transparency = element.transparency
        self.display = element.display
        self.createDisplays = element.createDisplays
        self.disappearDisplays = element.disappearDisplays
        self.rotationDegrees = element.rotationDegrees
        self.linkOnClick = element.linkOnClick
        self.soundOnClick = element.soundOnClick
        self.defaultDisplaySetting = element.defaultDisplaySetting
    }
    
    enum CodingKeys: CodingKey {
        case id
        case currentShape
        case position
        case size
        case scalar
        case transparency
        case display
        case createDisplays
        case disappearDisplays
        case rotationDegrees
        case linkOnClick
        case soundOnClick
        case defaultDisplaySetting
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(currentShape, forKey: .currentShape)
        try container.encode(position, forKey: .position)
        try container.encode(size, forKey: .size)
        try container.encode(scalar, forKey: .scalar)
        try container.encode(transparency, forKey: .transparency)
        try container.encode(display, forKey: .display)
        try container.encode(createDisplays, forKey: .createDisplays)
        try container.encode(disappearDisplays, forKey: .disappearDisplays)
        try container.encode(rotationDegrees.degrees, forKey: .rotationDegrees)
        try container.encode(linkOnClick, forKey: .linkOnClick)
        try container.encode(soundOnClick, forKey: .soundOnClick)
        try container.encode(defaultDisplaySetting, forKey: .defaultDisplaySetting)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        currentShape = try container.decode(ClippableShape.self, forKey: .currentShape)
        position = try container.decode(CGSize.self, forKey: .position)
        size = try container.decode(CGSize.self, forKey: .size)
        scalar = try container.decode(Double.self, forKey: .scalar)
        transparency = try container.decode(Double.self, forKey: .transparency)
        display = try container.decode(Bool.self, forKey: .display)
        createDisplays = try container.decode([String].self, forKey: .createDisplays)
        disappearDisplays = try container.decode([String].self, forKey: .disappearDisplays)
        rotationDegrees = Angle(degrees: (try container.decode(Double.self, forKey: .rotationDegrees)))
        linkOnClick = try container.decode(URL?.self, forKey: .linkOnClick)
        soundOnClick = try container.decode(URL?.self, forKey: .soundOnClick)
        defaultDisplaySetting = try container.decode(Bool.self, forKey: .defaultDisplaySetting)
    }
    
}

class postImage: postElement {
    let url: URL
    let imageReferenceID: String
    
    init(imgSrc: URL, imageReferenceID: String, element: editorImage) {
        self.url = imgSrc
        self.imageReferenceID = imageReferenceID
        
        super.init(from: element)
    }
    
    private enum CodingKeys: CodingKey {
        case url
        case imageReferenceID
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(url, forKey: .url)
        try container.encode(imageReferenceID, forKey: .imageReferenceID)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
        imageReferenceID = try container.decode(String.self, forKey: .imageReferenceID)
        
        try super.init(from: decoder)
    }
}

class postVideo: postElement {
    let videoURL: URL
    let videoReferenceID: String
    
    init(videoURL: URL, videoReferenceID: String, element: editorVideo) {
        self.videoURL = videoURL
        self.videoReferenceID = videoReferenceID
        super.init(from: element)
    }
    
    private enum CodingKeys: CodingKey {
        case videoURL
        case videoReferenceID
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(videoURL, forKey: .videoURL)
        try container.encode(videoReferenceID, forKey: .videoReferenceID)
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        videoURL = try container.decode(URL.self, forKey: .videoURL)
        videoReferenceID = try container.decode(String.self, forKey: .videoReferenceID)
        
        try super.init(from: decoder)
    }
}

class postShape: postElement {
    let color: Color
    
    init(from element: editorShape) {
        self.color = element.color
        super.init(from: element)
    }
    
    private enum CodingKeys: CodingKey {
        case color
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Convert Color to RGB components
        let colorComponents = colorComponentsFromColor(color)
        
        try container.encode(colorComponents, forKey: .color)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorArray = try container.decode([Double].self, forKey: .color)
        
        // Convert RGB components to Color
        color = colorFromComponents(colorArray)
        
        try super.init(from: decoder)
    }
}

class postSticker: postElement {
    let sticker: URL
    
    init(from element: editorSticker) {
        self.sticker = element.sticker
        super.init(from: element)
    }
    
    private enum CodingKeys: CodingKey {
        case sticker
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(sticker, forKey: .sticker)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sticker = try container.decode(URL.self, forKey: .sticker)
        
        try super.init(from: decoder)
    }
    
}

class postPoll: postElement {
    let question: String
    let responses: [String]
    let topColor: Color
    let bottomColor: Color
    let buttonColor: Color
    
    init(from element: editorPoll) {
        question = element.question
        responses = element.responses
        topColor = element.topColor
        bottomColor = element.bottomColor
        buttonColor = element.buttonColor
        super.init(from: element)
    }
    
    private enum CodingKeys: CodingKey {
        case question
        case responses
        case topColor
        case bottomColor
        case buttonColor
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(question, forKey: .question)
        try container.encode(responses, forKey: .responses)
        try container.encode(colorComponentsFromColor(topColor), forKey: .topColor)
        try container.encode(colorComponentsFromColor(bottomColor), forKey: .bottomColor)
        try container.encode(colorComponentsFromColor(buttonColor), forKey: .buttonColor)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        question = try container.decode(String.self, forKey: .question)
        responses = try container.decode([String].self, forKey: .responses)
        topColor = colorFromComponents(try container.decode([Double].self, forKey: .topColor))
        bottomColor = colorFromComponents(try container.decode([Double].self, forKey: .bottomColor))
        buttonColor = colorFromComponents(try container.decode([Double].self, forKey: .buttonColor))
        
        try super.init(from: decoder)
    }
}

