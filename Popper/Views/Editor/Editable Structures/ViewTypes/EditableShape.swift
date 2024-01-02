//
//  EditableShape.swift
//  Popper
//
//  Created by Stanley Grullon on 11/3/23.
//

import SwiftUI

struct EditableShape: View {
    
    @ObservedObject var shape: editorShape
    @Binding var elementsArray: [String: editableElement]
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
                        
                        if sharedEditNotifier.selectedElement?.id == shape.id { Rectangle()
                                .stroke(Color.black, lineWidth: 5)
                        }
                        
                        if shape.lock {
                            elementLock(small: true)
                        }
                    }
                )
                .rotationEffect(currentRotation + shape.rotationDegrees)
                .scaleEffect(shape.scalar + currentAmount)
                .offset(shape.position)
                .opacity(shape.transparency)
                .zIndex(sharedEditNotifier.textEdited() ? 0.0 : 1.0) // Controls layer
            
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
