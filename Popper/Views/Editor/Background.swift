//
//  Background.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

struct Background: View {
    
    @ObservedObject var sharedEditNotifier: SharedEditState
    @ObservedObject var elementsArray: editorElementsArray
    
    var body: some View {
        
        ZStack {
            Color(.white)
                .onTapGesture {
                    sharedEditNotifier.restoreDefaults()
                }
                
            
            ForEach(elementsArray.elements.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                if let itemToDisplay = elementsArray.elements[key] {
                    EditableElement(element: itemToDisplay, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
                        .disabled(true)
                }
            }
        }
        .zIndex(-1)
        
        
    }
}
