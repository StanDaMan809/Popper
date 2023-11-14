//
//  ElementView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/13/23.
//

import SwiftUI

struct ElementView: View {
    
    @ObservedObject var element: editorElement
    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    @State var textEditPrio: Double = 1.0
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    @Binding var textSelected: Bool
    
    var body: some View {
        switch element.element {
        case .image(let editableImage):
                
            EditableImage(image: editableImage, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation)
            
        case .video(let editableVid):
            
            EditableVideo(video: editableVid, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation)
            
        case .text(let editableTxt):
            
            EditableText(text: editableTxt, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation, textSelected: $textSelected, editPrio: $textEditPrio)
                .onChange(of: sharedEditNotifier.objectsCount) { _ in
                    textEditPrio = Double(sharedEditNotifier.objectsCount + 2)
                }
            
        case .shape(let editableShp):
            
            EditableShape(shape: editableShp, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $currentRotation)
        }
    }
}
