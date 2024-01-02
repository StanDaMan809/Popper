//
//  EditableSticker.swift
//  Popper
//
//  Created by Stanley Grullon on 11/16/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditableSticker: View {
    
    @ObservedObject var sticker: editorSticker
    @Binding var elementsArray: [String : editableElement]
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    
    var body: some View
        {
            if sticker.display
            {
                AnimatedImage(url: sticker.sticker)
                    // Image characteristics
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(sticker.currentShape)
                        .overlay(
                            Group {
                                if sharedEditNotifier.selectedElement?.id == sticker.id { Rectangle()
                                        .stroke(Color.black, lineWidth: 5)}
                                
                                if sticker.lock {
                                    elementLock()
                                }
                            }
                        )
                        .rotationEffect(currentRotation + sticker.rotationDegrees)
                        .scaleEffect(sticker.scalar + currentAmount)
                        .offset(sticker.position)
                        .opacity(sticker.transparency)
                        .zIndex(sharedEditNotifier.textEdited() ? 0.0 : 1.0)
            }
        }
}
