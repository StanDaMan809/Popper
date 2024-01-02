//
//  Background.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

struct Background: View {
    
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var elementsArray: [String : editableElement]
    
    var body: some View {
        
        ZStack {
            ForEach(elementsArray.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                if let itemToDisplay = elementsArray[key] {
                    EditableElement(element: itemToDisplay, elementsArray: $elementsArray, sharedEditNotifier: sharedEditNotifier)
                        .disabled(true) // If the background is being edited, this view doesn't exist, we don't want the background to be interactable
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture{ sharedEditNotifier.restoreDefaults() }
        .zIndex(0)
        
        
    }
}
