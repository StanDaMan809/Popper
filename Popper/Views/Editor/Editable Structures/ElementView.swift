//
//  ElementView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/13/23.
//

import SwiftUI

struct ElementView: View {
    
    @ObservedObject var element: editableElement
    @Binding var elementsArray: [String : editableElement]
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    
    var body: some View {
        
        if let element = element as? editorImage {
            EditableImage(image: element, elementsArray: $elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation)
        }
        
        if let element = element as? editorVideo {
            EditableVideo(video: element, elementsArray: $elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation)
        }
        
        if let element = element as? editorText {
            EditableText(text: element, elementsArray: $elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation)
        }
        
        if let element = element as? editorShape {
            EditableShape(shape: element, elementsArray: $elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation)
        }
        
        if let element = element as? editorSticker {
            EditableSticker(sticker: element, elementsArray: $elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation)
        }
        
        if let element = element as? editorPoll {
            EditablePoll(poll: element, elementsArray: $elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation)
        }
    }
}
