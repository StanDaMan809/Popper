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
    @Published var size: [CGFloat] = [80, 40]
    @Published var scalar: Double
    @Published var rotationDegrees: Angle = Angle(degrees: 0.0)
    let defaultDisplaySetting: Bool
    var startPosition: CGPoint
    
    
    init(id: Int, message: String, totalOffset: CGPoint, display: Bool, size: [CGFloat], scalar: Double, defaultDisplaySetting: Bool)
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
    @ObservedObject var sharedEditNotifier: SharedEditState
    @State var currentAmount = 0.0
    @GestureState var currentRotation = Angle.zero
    @State var textSelected = false
    var editPrio: Double = 1
    
    var body: some View
    { if text.display
            {
                if textSelected, sharedEditNotifier.selectedText != nil {
                    
                    Color.black
                        .opacity(0.2)
                        .zIndex(editPrio)
                        .edgesIgnoringSafeArea(.all)
                    
                        .onTapGesture {
                            textSelected.toggle()
                            sharedEditNotifier.restoreDefaults()
                        }
                    
                    TextField("", text: $text.message, axis: .vertical)
                        .font(text.font)
                        .foregroundColor(text.color)
                        .background(text.bgColor)
                        .offset(x: 0, y: -100)
//                        .frame(width: defaultTextFrame)
                        .zIndex(editPrio) // Controls layer
                        .multilineTextAlignment(.center)
                        .onSubmit {
                            textSelected.toggle()
                            sharedEditNotifier.restoreDefaults()
                        }
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
                        .position(text.totalOffset)
                        .zIndex(Double(text.id)) // Controls layer
                        .multilineTextAlignment(.center)
                        
                        
                        
                        // Text gestures
                        .onTapGesture
                        {
                            textSelected.toggle()
                            sharedEditNotifier.pressedButton = .textEdit
                            sharedEditNotifier.selectText(editableTxt: text)
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let scaledWidth = text.size[0] * CGFloat(text.scalar)
                                    let scaledHeight = text.size[1] * CGFloat(text.scalar)
                                    let halfScaledWidth = scaledWidth / 2
                                    let halfScaledHeight = scaledHeight / 2
                                    let newX = gesture.location.x
                                    let newY = gesture.location.y
                                    text.totalOffset = CGPoint(x: newX, y: newY)
                                    
                                    sharedEditNotifier.currentlyEdited = true
                                    sharedEditNotifier.editToggle()
                                            }
                            
                                .onEnded { gesture in
                                    text.startPosition = text.totalOffset
                                    
                                    sharedEditNotifier.currentlyEdited = false
                                    sharedEditNotifier.editToggle()
                                })
                    
    //                    .gesture(
    //                        RotationGesture()
    //                        .updating($currentRotation) { value, state, _ in state = value }
    //                                .onEnded { value in
    //                                        finalRotation += value
    //                                               })
    //
    //                    .gesture(
    //                        MagnificationGesture()
    //                            .onChanged { amount in
    //                                currentAmount = amount - 1
    //                            }
    //                            .onEnded { amount in
    //                                text.scalar += currentAmount
    //                                currentAmount = 0
    //                            })
                    
                        .gesture(
                            SimultaneousGesture(
                                RotationGesture()
                                    .updating($currentRotation) { value, state, _ in state = value }
                                    .onEnded { value in
                                        text.rotationDegrees += value
                                    },
                                MagnificationGesture()
                                    .onChanged { amount in
                                        currentAmount = amount - 1
                                    }
                                    .onEnded { amount in
                                        text.scalar += currentAmount
                                        currentAmount = 0
                                    }
                            )
                        )
                    
                    
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
        self.size = editableText.size.map { Double($0) }
        self.scalar = editableText.scalar
        self.rotationDegrees = editableText.rotationDegrees.degrees
    }
}
