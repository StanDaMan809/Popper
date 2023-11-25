//
//  PostStickerView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/19/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostStickerView: View {
    @ObservedObject var sticker: postSticker
    @ObservedObject var elementsArray: postElementsArray
    
    var body: some View {
        if sticker.display {
            WebImage(url: sticker.url)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(sticker.currentShape)
                .rotationEffect(Angle(degrees: sticker.rotationDegrees))
                .scaleEffect(sticker.scalar)
                .position(CGPoint(x: sticker.totalOffset[0], y: sticker.totalOffset[1]))
                .opacity(sticker.transparency)
                .zIndex(Double(sticker.id)) // Controls layer
        }
        
    }
    
}


// Handle the imagesArray data from post
class postSticker: ObservableObject {
    let id: Int
    let url: URL
    let currentShape: ClippableShape
    let totalOffset: [Double]
    let scalar: Double
    let rotationDegrees: Double
    let transparency: Double
    @Published var display: Bool
    let soundOnClick: URL?
    let createDisplays: [Int]
    let disappearDisplays: [Int]
    let defaultDisplaySetting: Bool
    
    init(sticker: EditableStickerData) {
        self.id = sticker.id
        self.url = sticker.url
        self.currentShape = ClippableShape(rawValue: sticker.currentShape) ?? .square
        self.totalOffset = [sticker.totalOffset[0], sticker.totalOffset[1]]
        self.scalar = sticker.scalar
        self.rotationDegrees = sticker.rotationDegrees
        self.transparency = sticker.transparency
        self.display = sticker.defaultDisplaySetting
        self.soundOnClick = sticker.soundOnClick
        self.createDisplays = sticker.createDisplays
        self.disappearDisplays = sticker.disappearDisplays
        self.defaultDisplaySetting = sticker.defaultDisplaySetting
    }
}

struct EditableStickerData: Codable, Equatable, Hashable {
    let id: Int
    let currentShape: Int
    let totalOffset: [Double]
    let scalar: Double
    let transparency: Double
    let display: Bool
    var createDisplays: [Int] = []
    var disappearDisplays: [Int] = []
    let rotationDegrees: Double
    let soundOnClick: URL?
    let defaultDisplaySetting: Bool
    let url: URL
    
    init(from editableSticker: editableStick) {
        self.id = editableSticker.id
        self.currentShape = editableSticker.currentShape.rawValue // For encoding
        self.totalOffset = [Double(editableSticker.totalOffset.x), Double(editableSticker.totalOffset.y)] // For encoding
        self.scalar = editableSticker.scalar
        self.transparency = editableSticker.transparency
        self.display = editableSticker.defaultDisplaySetting // If user uploads a post that's already interacted with, it'll upload just fine
        self.createDisplays = editableSticker.createDisplays
        self.disappearDisplays = editableSticker.disappearDisplays
        self.rotationDegrees = editableSticker.rotationDegrees.degrees
        self.soundOnClick = editableSticker.soundOnClick
        self.defaultDisplaySetting = editableSticker.defaultDisplaySetting
        self.url = editableSticker.url
    }
    
}
