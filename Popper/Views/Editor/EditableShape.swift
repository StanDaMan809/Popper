//
//  EditableShape.swift
//  Popper
//
//  Created by Stanley Grullon on 11/3/23.
//

import SwiftUI

class editableShp: ObservableObject {
    @Published var id: Int
    // Include color as a dimension
    // Include font as a dimension
    // Include alignment
    @Published var currentShape: ClippableShape = .rectangle
    @Published var totalOffset: CGPoint = CGPoint(x:0, y: 0)
    @Published var color: Color = .black
    @Published var rValue: Double = 0.0
    @Published var gValue: Double = 0.0
    @Published var bValue: Double = 0.0
    @Published var transparency: Double
    @Published var display: Bool
    @Published var size: [CGFloat] = [80, 80]
    @Published var scalar: Double
    @Published var rotationDegrees: Double
    var startPosition: CGPoint
    let defaultDisplaySetting: Bool
    
    init(id: Int, totalOffset: CGPoint, transparency: Double, display: Bool, scalar: Double, rotationDegrees: Double, defaultDisplaySetting: Bool)
    {
        self.id = id
        self.totalOffset = totalOffset
        self.transparency = transparency
        self.display = display
        self.scalar = scalar
        self.rotationDegrees = rotationDegrees
        self.startPosition = totalOffset
        self.defaultDisplaySetting = defaultDisplaySetting
    }
}

struct EditableShape: View {
    
    @ObservedObject var shape: editableShp
    @ObservedObject var sharedEditNotifier: SharedEditState
    @State var currentAmount = 0.0
    @GestureState var currentRotation = Angle.zero
    @State var finalRotation = Angle.zero
    
    var body: some View {
        Color(red: shape.rValue, green: shape.gValue, blue: shape.bValue)
            .foregroundStyle(shape.color)
            .frame(width: shape.size[0], height: shape.size[1])
            .clipShape(shape.currentShape)
            .rotationEffect(currentRotation + finalRotation)
            .scaleEffect(shape.scalar + currentAmount)
            .position(shape.totalOffset)
            .zIndex(Double(shape.id)) // Controls layer
        
            .onTapGesture (count: 2)
            {
                shape.currentShape = shape.currentShape.next
            }
        
        //            .onTapGesture
        //            {
        //                if sharedEditNotifier.editorDisplayed == .photoDisappear {
        //                    sharedEditNotifier.selectedImage?.disappearDisplays.append(self.image.id)
        //                    sharedEditNotifier.editorDisplayed = .none
        //                }
        //
        //                else
        //                {
        //                        for i in image.createDisplays
        //                        {
        //                            print("Retrieving for \(i)...")
        //                            if let itemToDisplay = imgArray.images[i] {
        //                                itemToDisplay.display = true
        //                            } else { }// else if textArray blah blah blah
        //                        }
        //
        //                        for i in image.disappearDisplays
        //                        {
        //                            if let itemToDisplay = imgArray.images[i] {
        //                                itemToDisplay.display = false
        //                            } // else if textArray blah blah blah
        //                        }
        //                }
        
        
        //                    }
        
        .gesture(
            DragGesture() // Have to add UI disappearing but not yet
                .onChanged { gesture in
                    let scaledWidth = shape.size[0] * CGFloat(shape.scalar)
                    let scaledHeight = shape.size[1] * CGFloat(shape.scalar)
                    let halfScaledWidth = scaledWidth / 2
                    let halfScaledHeight = scaledHeight / 2
                    let newX = gesture.location.x
                    let newY = gesture.location.y
                    shape.totalOffset = CGPoint(x: newX, y: newY)
                    sharedEditNotifier.currentlyEdited = true
                    sharedEditNotifier.editToggle()
                }
            
                .onEnded { gesture in
                    shape.startPosition = shape.totalOffset
                    sharedEditNotifier.currentlyEdited = false
                    sharedEditNotifier.editToggle()
                })
        
        .gesture(
            SimultaneousGesture( // Rotating and Size change
                RotationGesture()
                    .updating($currentRotation) { value, state, _ in state = value
                    }
                    .onEnded { value in
                        finalRotation += value
                    },
                MagnificationGesture()
                    .onChanged { amount in
                        currentAmount = amount - 1
                        sharedEditNotifier.currentlyEdited = true
                        sharedEditNotifier.editToggle()
                    }
                    .onEnded { amount in
                        shape.scalar += currentAmount
                        currentAmount = 0
                        sharedEditNotifier.currentlyEdited = false
                        sharedEditNotifier.editToggle()
                        
                    }))
    }
}

class shapesArray: ObservableObject {
    @Published var shapes: [Int : editableShp] = [:]
//        editableImg(id: 0, imgSrc: "Image", currentShape: .rectangle, totalOffset: CGPoint(x: 150, y: 500), size: [50, 80], scalar: 1.0),
//        editableImg(id: 1, imgSrc: "Slay", currentShape: .rectangle, totalOffset: CGPoint(x: 70, y: 500), size: [50, 80], scalar: 1.0)
}

func shapeAdd(shapeArray: shapesArray, sharedEditNotifier: SharedEditState) {
    
    shapeArray.shapes[sharedEditNotifier.objectsCount] = editableShp(id: sharedEditNotifier.objectsCount, totalOffset: CGPoint(x: 300, y: 150), transparency: 1, display: true, scalar: 1, rotationDegrees: 0.0, defaultDisplaySetting: true)
    
    sharedEditNotifier.objectsCount += 1
}
