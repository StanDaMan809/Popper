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
    @Published var position: CGSize = CGSize.zero
    @Published var color: Color = .black
    @Published var rValue: Double = 0.0
    @Published var gValue: Double = 0.0
    @Published var bValue: Double = 0.0
    @Published var transparency: Double = 1.0
    @Published var display: Bool
    @Published var size: CGSize = CGSize(width: 100, height: 100)
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var scalar: Double = 1.0
    @Published var rotationDegrees: Angle = Angle.zero
    @Published var soundOnClick: URL? 
    @Published var lock: Bool = false
    var startPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    let defaultDisplaySetting: Bool
    
    init(id: Int, defaultDisplaySetting: Bool)
    {
        self.id = id
        self.display = defaultDisplaySetting
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
                        
                        if sharedEditNotifier.selectedElement?.element.id == shape.id { Rectangle()
                                .stroke(Color.black, lineWidth: 5)
                        }
                        
                        if shape.lock {
                            elementLock(id: shape.id, small: true)
                        }
                    }
                )
                .rotationEffect(currentRotation + shape.rotationDegrees)
                .scaleEffect(shape.scalar + currentAmount)
                .offset(shape.position)
                .opacity(shape.transparency)
                .zIndex(sharedEditNotifier.textEdited() ? 0.0 : Double(shape.id)) // Controls layer
            
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
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .shape(editableShp(id: elementsArray.objectsCount, defaultDisplaySetting: defaultDisplaySetting)))
    
    elementsArray.objectsCount += 1
}
