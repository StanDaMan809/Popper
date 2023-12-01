//
//  PostImageView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostImageView: View {
    @ObservedObject var image: postImage
    @ObservedObject var elementsArray: postElementsArray
    
    var body: some View {
        if image.display {
            WebImage(url: image.imgSrc)
                .resizable()
                
                .frame(width: image.size[0]*image.scalar, height: image.size[1]*image.scalar)
                
                .clipShape(image.currentShape)
                
                .rotationEffect(Angle(degrees: image.rotationDegrees))
//                .scaleEffect(image.scalar)
                .offset(image.position)
                .opacity(image.transparency)
                .zIndex(Double(image.id)) // Controls layer
        }
        
    }
    
}


// Handle the imagesArray data from post
class postImage: ObservableObject {
    let id: Int
    let imgSrc: URL
    let currentShape: ClippableShape
    let position: CGSize
    let size: [Double]
    let scalar: Double
    let rotationDegrees: Double
    let transparency: Double
    @Published var display: Bool
    let linkOnClick: URL?
    let soundOnClick: URL?
    let createDisplays: [Int]
    let disappearDisplays: [Int]
    let defaultDisplaySetting: Bool
    let imageReferenceID: String
    
    init(image: EditableImageData) {
        self.id = image.id
        self.imgSrc = image.imageURL
        self.currentShape = ClippableShape(rawValue: image.currentShape) ?? .square
        self.position = CGSize(width: image.position[0], height: image.position[1])
        self.size = image.size
        self.scalar = image.scalar
        self.rotationDegrees = image.rotationDegrees
        self.transparency = image.transparency
        self.display = image.defaultDisplaySetting
        self.linkOnClick = image.linkOnClick
        self.soundOnClick = image.soundOnClick
        self.createDisplays = image.createDisplays
        self.disappearDisplays = image.disappearDisplays
        self.defaultDisplaySetting = image.defaultDisplaySetting
        self.imageReferenceID = image.imageReferenceID
    }
}

struct EditableImageData: Codable, Equatable, Hashable {
    let id: Int
    let currentShape: Int
    let position: [Double]
    let size: [Double]
    let scalar: Double
    let transparency: Double
    let display: Bool
    var createDisplays: [Int] = []
    var disappearDisplays: [Int] = []
    let rotationDegrees: Double
    let linkOnClick: URL?
    let soundOnClick: URL?
    let defaultDisplaySetting: Bool
    let imageURL: URL
    let imageReferenceID: String
    
    init(from editableImage: editableImg, imageURL: URL, imageReferenceID: String) {
        self.id = editableImage.id
        self.currentShape = editableImage.currentShape.rawValue // For encoding
        self.position = [Double(editableImage.position.width), Double(editableImage.position.height)] // For encoding
        self.size = [Double(editableImage.size.width), Double(editableImage.size.height)] // For encoding
        self.scalar = editableImage.scalar
        self.transparency = editableImage.transparency
        self.display = editableImage.defaultDisplaySetting // If user uploads a post that's already interacted with, it'll upload just fine
        self.createDisplays = editableImage.createDisplays
        self.disappearDisplays = editableImage.disappearDisplays
        self.rotationDegrees = editableImage.rotationDegrees.degrees
        self.linkOnClick = editableImage.linkOnClick
        self.soundOnClick = editableImage.soundOnClick
        self.defaultDisplaySetting = editableImage.defaultDisplaySetting
        self.imageURL = imageURL
        self.imageReferenceID = imageReferenceID
    }
    
}


