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
    @Published var font: Font = Font.custom("BarlowCondensed-Medium", size: defaultTextSize)
    @Published var message: String
    @Published var currentShape: ClippableShape = .roundedrectangle
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
    @Published var soundOnClick: URL? 
    @Published var rotationDegrees: Angle = Angle(degrees: 0.0)
    @Published var lock: Bool = false
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
    @Binding var editPrio: Double
    @State var priority: Double = 0
    
    var body: some View
    { if text.display
            {
        if amISelected(), sharedEditNotifier.editorDisplayed != .elementDisappear {
                    
                        Color.black
                            .opacity(0.2)
                            
                            .edgesIgnoringSafeArea(.all)
                        
                            .onTapGesture {
                                sharedEditNotifier.restoreDefaults()
                            }
                            .zIndex(Double(text.id))
                            
                        
                        TextField("", text: $text.message, axis: .vertical)
                            .font(text.font)
                            .fontWeight(.bold)
                            .foregroundColor(text.color)
                            .background(text.bgColor)
                            .offset(x: 0, y: -100)
        //                        .frame(width: defaultTextFrame)
        //                        .zIndex(Double(sharedEditNotifier.objectsCount + 1)) // Controls layer
                            .multilineTextAlignment(.center)
                            .onSubmit {
                                sharedEditNotifier.restoreDefaults()
                            }
                            .zIndex(Double(text.id))
                            
                }
                else
                {
                    Text(text.message)
                        // Text characteristics
                        .font(text.font)
                        .fontWeight(.bold)
//                        .frame(width: defaultTextFrame)
                        .foregroundColor(text.color)
                        .padding()
                        .background(
                            shapeForClippableShape(shape: text.currentShape)
                                .foregroundStyle(text.bgColor)
                        )
                        .overlay(
                            Group {
                                if text.lock {
                                    elementLock(id: text.id, small: true)
                                }
                            }
                        )
                        .rotationEffect(currentRotation + text.rotationDegrees)
                        .scaleEffect(text.scalar + currentAmount)
                        .opacity(text.transparency)
                        .position(text.totalOffset)
                        .zIndex(sharedEditNotifier.textEdited() ? 0.0 : Double(text.id)) // Controls layer
                        .multilineTextAlignment(.center)
                    
                    
                }
                
            }
        }
    
    func amISelected() -> Bool {
        if sharedEditNotifier.selectedElement?.element.id == text.id {
            return true
        } else {
            return false
        }
    }
    
    func generateIndex() -> Double {
        return Double(sharedEditNotifier.objectsCount) + 1
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

func textAdd(elementsArray: editorElementsArray, sharedEditNotifier: SharedEditState) {
    
    var defaultDisplaySetting = true
    
    if sharedEditNotifier.editorDisplayed == .photoAppear {
        if let currentElement = sharedEditNotifier.selectedElement {
            currentElement.element.createDisplays.append(elementsArray.objectsCount)
            defaultDisplaySetting = false
        }
    }
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .text(editableTxt(id: elementsArray.objectsCount, message: "Hold to Edit", totalOffset: CGPoint(x: 200, y: 400), display: defaultDisplaySetting, size: CGSize(width: 80, height: 80), scalar: 1.0, defaultDisplaySetting: defaultDisplaySetting)))
    
    elementsArray.objectsCount += 1
}
