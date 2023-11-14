//
//  EditableText.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

// These are the text instances
class editableTxt: ObservableObject {
    @Published var id: Int
    // Include color as a dimension
    // Include font as a dimension
    // Include alignment
    @Published var font: Font = Font.system(size: defaultTextSize)
    @Published var message: String
    @Published var totalOffset: CGPoint = CGPoint(x:0, y: 0)
    @Published var color: Color = .black
    @Published var bgColor: Color = .clear
    @Published var rValue: Double = 0.0
    @Published var gValue: Double = 0.0
    @Published var bValue: Double = 0.0
    @Published var display: Bool
    @Published var transparency: Double = 1.0
    @Published var size: CGSize
    @Published var scalar: Double
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var rotationDegrees: Angle = Angle(degrees: 0.0)
    let defaultDisplaySetting: Bool
    var startPosition: CGPoint
    
    
    init(id: Int, message: String, totalOffset: CGPoint, display: Bool, size: CGSize, scalar: Double, defaultDisplaySetting: Bool)
    {
        self.id = id
        self.message = message
        self.totalOffset = totalOffset
        self.display = display
        self.size = size
        self.scalar = scalar
        self.defaultDisplaySetting = defaultDisplaySetting
        self.startPosition = totalOffset
    }
}

struct EditableText: View {
    
    @ObservedObject var text: editableTxt
    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    @Binding var textSelected: Bool
    @Binding var editPrio: Double
    
    var body: some View
    { if text.display
            {
        if textSelected, case .text = sharedEditNotifier.selectedElement?.element, sharedEditNotifier.editorDisplayed != .photoDisappear {
                    
                    Color.black
                        .opacity(0.2)
                        
                        .edgesIgnoringSafeArea(.all)
                    
                        .onTapGesture {
                            textSelected.toggle()
                            sharedEditNotifier.restoreDefaults()
                        }
                        .zIndex(editPrio)
                        
                    
                    TextField("", text: $text.message, axis: .vertical)
                        .font(text.font)
                        .foregroundColor(text.color)
                        .background(text.bgColor)
                        .offset(x: 0, y: -100)
    //                        .frame(width: defaultTextFrame)
    //                        .zIndex(Double(sharedEditNotifier.objectsCount + 1)) // Controls layer
                        .multilineTextAlignment(.center)
                        .onSubmit {
                            textSelected.toggle()
                            sharedEditNotifier.restoreDefaults()
                        }
                        .zIndex(editPrio)
                }
                else
                {
                    Text(text.message)
                        // Text characteristics
                        .font(text.font)
//                        .frame(width: defaultTextFrame)
                        .foregroundColor(text.color)
                        .background(text.bgColor)
                        .rotationEffect(currentRotation + text.rotationDegrees)
                        .scaleEffect(text.scalar + currentAmount)
                        .opacity(text.transparency)
                        .position(text.totalOffset)
                        .zIndex(Double(text.id)) // Controls layer
                        .multilineTextAlignment(.center)
            
                        
                        
//                        // Text gestures
//                        .onTapGesture
//                        {
//                            textSelected.toggle()
//                            sharedEditNotifier.pressedButton = .textEdit
//                            sharedEditNotifier.selectText(editableTxt: text)
//                        }
//                        .gesture(
//                            DragGesture()
//                                .onChanged { gesture in
//                                    let scaledWidth = text.size.width * CGFloat(text.scalar)
//                                    let scaledHeight = text.size.height * CGFloat(text.scalar)
//                                    let halfScaledWidth = scaledWidth / 2
//                                    let halfScaledHeight = scaledHeight / 2
//                                    let newX = gesture.location.x
//                                    let newY = gesture.location.y
//                                    text.totalOffset = CGPoint(x: newX, y: newY)
//                                    
//                                    sharedEditNotifier.currentlyEdited = true
//                                    sharedEditNotifier.toDelete = sharedEditNotifier.trashCanFrame.contains(gesture.location)
//                                    sharedEditNotifier.editToggle()
//                                            }
//                            
//                                .onEnded { gesture in
//                                    if sharedEditNotifier.trashCanFrame.contains(gesture.location) {
//                                        deleteElement(elementsArray: elementsArray, id: text.id)
//                                    } else {
//                                        text.startPosition = text.totalOffset
//                                    }
//                                    
//                                    sharedEditNotifier.currentlyEdited = false
//                                    sharedEditNotifier.editToggle()
//                                })
//                    
//    //                    .gesture(
//    //                        RotationGesture()
//    //                        .updating($currentRotation) { value, state, _ in state = value }
//    //                                .onEnded { value in
//    //                                        finalRotation += value
//    //                                               })
//    //
//    //                    .gesture(
//    //                        MagnificationGesture()
//    //                            .onChanged { amount in
//    //                                currentAmount = amount - 1
//    //                            }
//    //                            .onEnded { amount in
//    //                                text.scalar += currentAmount
//    //                                currentAmount = 0
//    //                            })
//                    
//                        .gesture(
//                            SimultaneousGesture(
//                                RotationGesture()
//                                    .updating($currentRotation) { value, state, _ in state = value }
//                                    .onEnded { value in
//                                        text.rotationDegrees += value
//                                    },
//                                MagnificationGesture()
//                                    .onChanged { amount in
//                                        currentAmount = amount - 1
//                                    }
//                                    .onEnded { amount in
//                                        text.scalar += currentAmount
//                                        currentAmount = 0
//                                    }
//                            )
//                        )
                    
                    
                }
                
            }
        }
}

struct EditableTextData: Codable, Equatable, Hashable {
    var id: Int
    var message: String
    var totalOffset: [Double]
    var rValue: Double
    var gValue: Double
    var bValue: Double
    var size: [Double]
    var scalar: Double
    var rotationDegrees: Double
    // need to add display 
    
    init(from editableText: editableTxt) {
        self.id = editableText.id
        self.message = editableText.message
        self.totalOffset = [Double(editableText.totalOffset.x), Double(editableText.totalOffset.y)]
        self.rValue = editableText.rValue
        self.gValue = editableText.gValue
        self.bValue = editableText.bValue
        self.size = [editableText.size.width, editableText.size.height]
        self.scalar = editableText.scalar
        self.rotationDegrees = editableText.rotationDegrees.degrees
    }
}
