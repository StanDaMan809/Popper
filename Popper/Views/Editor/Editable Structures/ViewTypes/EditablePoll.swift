//
//  EditablePoll.swift
//  Popper
//
//  Created by Stanley Grullon on 11/17/23.
//

import SwiftUI

struct EditablePoll: View {
    
    @ObservedObject var poll: editorPoll
    @Binding var elementsArray: [String : editableElement]
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    
    var body: some View {
        if poll.display {
            PollView(poll: poll, sharedEditNotifier: sharedEditNotifier)
            // Image characteristics
                .overlay(
                    Group {
                        
                        if sharedEditNotifier.selectedElement?.id == poll.id { Rectangle()
                                .stroke(Color.black, lineWidth: 5)
                        }
                        
                        if poll.lock {
                            elementLock(small: true)
                        }
                    }
                )
                .rotationEffect(currentRotation + poll.rotationDegrees)
                .scaleEffect(poll.scalar + currentAmount)
                .offset(poll.position)
                .opacity(poll.transparency)
                .zIndex(sharedEditNotifier.textEdited() ? 0.0 : 1.0)
            
        }
    }
}
