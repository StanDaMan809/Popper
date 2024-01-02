//
//  EditableImage.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

struct EditableImage: View {
    
    @ObservedObject var image: editorImage
    @Binding var elementsArray: [String : editableElement]
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    
    var body: some View
        {
            if image.display
            {
                    Image(uiImage: image.imgSrc)
                    // Image characteristics
                        .resizable()
                        .frame(width: image.size.width, height: image.size.height)
                        .clipShape(image.currentShape)
                        .overlay(
                            Group {
                                if sharedEditNotifier.selectedElement?.id == image.id { 
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 5)
                                }
                                
                                
                                if image.lock {
                                    elementLock()
                                }
                            }
                        )
                        .rotationEffect(currentRotation + image.rotationDegrees)
                        .scaleEffect(image.scalar + currentAmount)
                        .offset(image.position)
                        .opacity(image.transparency)
                        .zIndex(sharedEditNotifier.textEdited() ? 0.0 : 1.0 )
            }
        }
}



