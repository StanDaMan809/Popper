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
    @Published var message: String
    @Published var totalOffset: CGPoint = CGPoint(x:0, y: 0)
    @Published var color: Color = .black
    @Published var rValue: Double = 0.0
    @Published var gValue: Double = 0.0
    @Published var bValue: Double = 0.0
    @Published var size: [CGFloat] = [80, 40]
    @Published var scalar: Double
    @Published var rotationDegrees: Double
    var startPosition: CGPoint
    
    
    init(id: Int, message: String, totalOffset: CGPoint, size: [CGFloat], scalar: Double, rotationDegrees: Double)
    {
    self.id = id
    self.message = message
    self.totalOffset = totalOffset
    self.size = size
    self.scalar = scalar
    self.rotationDegrees = rotationDegrees
    self.startPosition = totalOffset
    }
}

struct EditableText: View {
    
    @ObservedObject var text: editableTxt
    @ObservedObject var sharedEditNotifier: SharedEditState
    @State var currentAmount = 0.0
    @GestureState var currentRotation = Angle.zero
    @State var finalRotation = Angle.zero
    @State var textSelected = false
    var editPrio: Double = 1
    
    var body: some View
        {
            if textSelected {
                
                // How to make button disappear
                    // Make a class of that enumerator thing that I made
                    // Make an @State variable that changes with it that is equal to the button UI
                    // Make an environment object that changes the enumerator to .disappeared? kinda changes everything?
                    // launch UIButtonWhatever(enum: disappeared)
                
                Color.black
                    .opacity(0.4)
                    .zIndex(editPrio)
                    .edgesIgnoringSafeArea(.all)
                
                    .onTapGesture {
                        textSelected.toggle()
                        sharedEditNotifier.pressedButton = .noButton
                    }
                
                TextField("", text: $text.message, axis: .vertical)
                    .font(.system(size: defaultTextSize))
                    .foregroundColor(text.color)
                    .offset(x: 0, y: -100)
                    .frame(width: defaultTextFrame)
                    .zIndex(editPrio) // Controls layer
                    .multilineTextAlignment(.center)
                    .onSubmit {
                        textSelected.toggle()
                        sharedEditNotifier.pressedButton = .noButton
                    }
            }
            else
            {
                Text(text.message)
                    // Text characteristics
                    .font(.system(size: defaultTextSize))
                    .frame(width: defaultTextFrame)
                    .rotationEffect(currentRotation + finalRotation)
                    .scaleEffect(text.scalar + currentAmount)
                    .position(text.totalOffset)
                    .zIndex(Double(text.id)) // Controls layer
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: text.rValue, green: text.gValue, blue: text.bValue))
                    
                    
                    // Text gestures
                    .onTapGesture
                    {
                        textSelected.toggle()
                        sharedEditNotifier.pressedButton = .textEdit
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
                                    finalRotation += value
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

class textsArray: ObservableObject {
    @Published var texts: [Int : editableTxt] = [ : ]
//       1 : editableTxt(id: 1, message: "Lorem Ipsum", totalOffset: CGPoint(x: 200, y: 400), txtColor: Color(red: 0.0, green: 0.0, blue: 0.0), size: [80, 80], scalar: 1.0, rotationDegrees: 0.0)
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
    
    init(from editableText: editableTxt) {
        self.id = editableText.id
        self.message = editableText.message
        self.totalOffset = [Double(editableText.totalOffset.x), Double(editableText.totalOffset.y)]
        self.rValue = editableText.rValue
        self.gValue = editableText.gValue
        self.bValue = editableText.bValue
        self.size = editableText.size.map { Double($0) }
        self.scalar = editableText.scalar
        self.rotationDegrees = editableText.rotationDegrees
    }
}
