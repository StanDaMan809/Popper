//
//  EditableText.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI
import UIKit

struct EditableText: View {
    
    @ObservedObject var text: editorText
    @Binding var elementsArray: [String : editableElement]
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    
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
                            .zIndex(1.0)
                            
                        
                        TextField("", text: $text.message, axis: .vertical)
                            .font(text.font)
                            .fontWeight(.bold)
                            .foregroundColor(text.color)
                            .background(text.bgColor)
                            .offset(x: 0, y: -100)
                            .multilineTextAlignment(.center)
                            .onSubmit {
                                sharedEditNotifier.restoreDefaults()
                            }
                            .zIndex(1.1)
                            
                }
                else
                {
                    Text(text.message)
                        // Text characteristics
                        .font(text.font)
                        .fontWeight(.bold)
                        .foregroundColor(text.color)
                        .padding()
                        .background(
                            shapeForClippableShape(shape: text.currentShape)
                                .foregroundStyle(text.bgColor)
                        )
                        .overlay(
                            Group {
                                
                                if text.lock {
                                    elementLock(small: true)
                                }
                            }
                        )
                        .rotationEffect(currentRotation + text.rotationDegrees)
                        .scaleEffect(text.scalar + currentAmount)
                        .opacity(text.transparency)
                        .offset(text.position)
                        .zIndex(sharedEditNotifier.textEdited() ? 0.0 : 1.0) // Controls layer
                        .multilineTextAlignment(.center)
                    
                    
                }
                
            }
        }
    
    func amISelected() -> Bool {
        if sharedEditNotifier.selectedElement?.id == text.id {
            return true
        } else {
            return false
        }
    }
}
