//
//  PostShapeView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI
import UIKit

struct PostShapeView: View {
    @ObservedObject var shape: postShape
    @ObservedObject var elementsArray: postElementsArray
    
    var body: some View {
        if shape.display {
            Rectangle()
                .frame(width: shape.size.width, height: shape.size.height)
                .clipShape(shape.currentShape)
                .foregroundStyle(shape.color)
                .rotationEffect(shape.rotationDegrees)
                .scaleEffect(shape.scalar)
                .offset(shape.position)
                .zIndex(Double(shape.id)) // Controls layer
                .opacity(shape.transparency)
            
        }
        
    }
    
}


// Handle the shapesArray data from post
class postShape: ObservableObject {
    let id: Int
    let currentShape: ClippableShape
    let color: Color
    let position: CGSize
    let size: CGSize
    let scalar: Double
    let transparency: Double
    @Published var display: Bool
    let createDisplays: [Int]
    let disappearDisplays: [Int]
    let rotationDegrees: Angle
    let soundOnClick: URL?
    let defaultDisplaySetting: Bool
    
    init(shape: EditableShapeData) {
        self.id = shape.id
        self.currentShape = ClippableShape(rawValue: shape.currentShape) ?? .square
        self.color = Color(red: shape.rValue, green: shape.gValue, blue: shape.bValue)
        self.position = CGSize(width: shape.position[0], height: shape.position[1])
        self.size = CGSizeMake(shape.size[0], shape.size[1])
        self.scalar = shape.scalar
        self.transparency = shape.transparency
        self.display = shape.display
        self.createDisplays = shape.createDisplays
        self.disappearDisplays = shape.disappearDisplays
        self.rotationDegrees = Angle(degrees: shape.rotationDegrees)
        self.soundOnClick = shape.soundOnClick
        self.defaultDisplaySetting = shape.defaultDisplaySetting
    }
}

struct EditableShapeData: Codable, Equatable, Hashable {
    let id: Int
    let currentShape: Int
    let position: [Double]
    let rValue: Double
    let gValue: Double
    let bValue: Double
    let size: [Double]
    let scalar: Double
    let transparency: Double
    let display: Bool
    var createDisplays: [Int] = []
    var disappearDisplays: [Int] = []
    let rotationDegrees: Double
    let soundOnClick: URL?
    let defaultDisplaySetting: Bool
    
    init(from editableShape: editableShp) {
        self.id = editableShape.id
        self.currentShape = editableShape.currentShape.rawValue // For encoding
        self.position = [Double(editableShape.position.width), Double(editableShape.position.height)] // For encoding
        self.size = [Double(editableShape.size.width), Double(editableShape.size.height)] // For encoding
        
        let color = UIColor(editableShape.color)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.rValue = red
        self.gValue = green
        self.bValue = blue
        
        self.scalar = editableShape.scalar
        self.transparency = editableShape.transparency
        self.display = editableShape.defaultDisplaySetting // If user uploads a post that's already interacted with, it'll upload just fine
        self.createDisplays = editableShape.createDisplays
        self.disappearDisplays = editableShape.disappearDisplays
        self.rotationDegrees = editableShape.rotationDegrees.degrees
        self.soundOnClick = editableShape.soundOnClick
        self.defaultDisplaySetting = editableShape.defaultDisplaySetting
    }
}

