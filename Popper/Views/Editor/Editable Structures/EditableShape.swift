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
    @Published var currentShape: ClippableShape = .roundedrectangle
    @Published var totalOffset: CGPoint = CGPoint(x:0, y: 0)
    @Published var color: Color = .black
    @Published var rValue: Double = 0.0
    @Published var gValue: Double = 0.0
    @Published var bValue: Double = 0.0
    @Published var transparency: Double
    @Published var display: Bool
    @Published var size: CGSize
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var scalar: Double
    @Published var rotationDegrees: Angle = Angle.zero
    @Published var lock: Bool = false
    var startPosition: CGPoint
    let defaultDisplaySetting: Bool
    
    init(id: Int, totalOffset: CGPoint, transparency: Double, display: Bool, size: CGSize, scalar: Double, defaultDisplaySetting: Bool)
    {
        self.id = id
        self.totalOffset = totalOffset
        self.transparency = transparency
        self.display = display
        self.size = size
        self.scalar = scalar
        self.startPosition = totalOffset
        self.defaultDisplaySetting = defaultDisplaySetting
    }
}

struct EditableShape: View {
    
    @ObservedObject var shape: editableShp
    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    
    var body: some View {
        
        if shape.display {
            Rectangle()
                .foregroundStyle(shape.color)
                .clipShape(shape.currentShape)
                .frame(width: shape.size.width, height: shape.size.height)
                .overlay(
                    Group {
                        if shape.lock {
                            elementLock(id: shape.id)
                        }
                    }
                )
                .rotationEffect(currentRotation + shape.rotationDegrees)
                .scaleEffect(shape.scalar + currentAmount)
                .position(shape.totalOffset)
                .opacity(shape.transparency)
                .zIndex(Double(shape.id)) // Controls layer
            
                .onTapGesture (count: 2)
                {
                    
                    shape.currentShape = shape.currentShape.next
                    
                    switch shape.currentShape {
                        case .square:
                            shape.size.height = shape.size.width
                        case .roundedsquare:
                            shape.size.height = shape.size.width
                        case .rectangle:
                            shape.size.height = 2 * shape.size.width
                        case .roundedrectangle:
                            shape.size.height = 2 * shape.size.width
                        case .circle:
                            shape.size.height = shape.size.width
                        case .ellipse:
                            shape.size.height = 2 * shape.size.width
                        case .capsule:
                            shape.size.height = 2 * shape.size.width
                        case .triangle:
                            shape.size.height = shape.size.width
                        case .star:
                            shape.size.height = shape.size.width
                        }
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
            
//            .gesture(
//                DragGesture() // Have to add UI disappearing but not yet
//                    .onChanged { gesture in
////                        let scaledWidth = shape.size.width * CGFloat(shape.scalar)
////                        let scaledHeight = shape.height * CGFloat(shape.scalar)
//                        let newX = gesture.location.x
//                        let newY = gesture.location.y
//                        shape.totalOffset = CGPoint(x: newX, y: newY)
//                        sharedEditNotifier.currentlyEdited = true
//                        sharedEditNotifier.toDelete = sharedEditNotifier.trashCanFrame.contains(gesture.location)
//                        sharedEditNotifier.editToggle()
//                    }
//                
//                    .onEnded { gesture in
//                        if sharedEditNotifier.trashCanFrame.contains(gesture.location) {
//                            deleteElement(elementsArray: elementsArray, id: shape.id)
//                        } else {
//                            shape.startPosition = shape.totalOffset
//                        }
//                        sharedEditNotifier.currentlyEdited = false
//                        sharedEditNotifier.editToggle()
//                    })
//            
//            .gesture(
//                SimultaneousGesture( // Rotating and Size change
//                    RotationGesture()
//                        .updating($currentRotation) { value, state, _ in state = value
//                        }
//                        .onEnded { value in
//                            shape.rotationDegrees += value
//                        },
//                    MagnificationGesture()
//                        .onChanged { amount in
//                            currentAmount = amount - 1
//                            sharedEditNotifier.currentlyEdited = true
//                            sharedEditNotifier.editToggle()
//                        }
//                        .onEnded { amount in
//                            shape.scalar += currentAmount
//                            currentAmount = 0
//                            sharedEditNotifier.currentlyEdited = false
//                            sharedEditNotifier.editToggle()
//                            
//                        }))
//            
//            .gesture(LongPressGesture()
//                .onEnded{_ in
//            sharedEditNotifier.pressedButton = .shapeEdit
//            sharedEditNotifier.selectShape(editableShp: shape)
//                    })
        }
    }
}

func shapeAdd(elementsArray: editorElementsArray, sharedEditNotifier: SharedEditState) {
    
    var defaultDisplaySetting = true
    
    if sharedEditNotifier.editorDisplayed == .photoAppear {
        if let currentElement = sharedEditNotifier.selectedElement {
            currentElement.element.createDisplays.append(elementsArray.objectsCount)
            defaultDisplaySetting = false
        }
    }
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .shape(editableShp(id: elementsArray.objectsCount, totalOffset: CGPoint(x: 200, y: 400), transparency: 1, display: defaultDisplaySetting, size: CGSize(width: 200, height: 200), scalar: 1, defaultDisplaySetting: defaultDisplaySetting)))
    
    elementsArray.objectsCount += 1
}
