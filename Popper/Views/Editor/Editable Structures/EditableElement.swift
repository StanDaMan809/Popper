//
//  EditableElement.swift
//  Popper
//
//  Created by Stanley Grullon on 11/13/23.
//

import SwiftUI
import AVFoundation

struct EditableElement: View {
    
    @ObservedObject var element: editorElement
    @ObservedObject var elementsArray: editorElementsArray
    @State var currentAmount = 0.0
    @ObservedObject var sharedEditNotifier: SharedEditState
    @GestureState var currentRotation = Angle.zero
    @State private var rotationToSend = Angle.zero // This is the rotation to send, cannot convert gesturestate to binding
    @State private var audioPlayer: AVAudioPlayer?
    @State private var timer: Timer?
    
    var body: some View {
        
        ElementView(element: element, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier, currentAmount: $currentAmount, currentRotation: $rotationToSend)
        
            .onTapGesture (count: 2)
        {
            if !element.element.lock {
                element.element.currentShape = element.element.currentShape.next
            }
        }
        
        .onTapGesture
        {
            if sharedEditNotifier.editorDisplayed == .elementDisappear { // If you touch something while the editor is in "choose an element to disappear" mode, this is the code that adds that element to that
                sharedEditNotifier.selectedElement?.element.disappearDisplays.append(self.element.element.id)
                sharedEditNotifier.editorDisplayed = .none
            }
            
            else if sharedEditNotifier.editorDisplayed == .photoAppear {
                sharedEditNotifier.selectedElement?.element.createDisplays.append(self.element.element.id)
                sharedEditNotifier.editorDisplayed = .none
            }
            
            else
            {
                // Play sound on the structure
                
                if let soundToPlay = element.element.soundOnClick {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: soundToPlay)
                        audioPlayer?.play()
                    } catch {
                        print("Error playing audio: \(error.localizedDescription)")
                    }
                }
                
                // Make all displays linked to this one appear!
                for i in element.element.createDisplays
                {
                    print("Retrieving for \(i)...")
                    if let itemToDisplay = elementsArray.elements[i] {
                        itemToDisplay.element.display = true
                    } else { }// else if textArray blah blah blah
                }
                
                // Make all displays linked to this one disappear
                for i in element.element.disappearDisplays
                {
                    if let itemToDisplay = elementsArray.elements[i] {
                        itemToDisplay.element.display = false
                    } // else if textArray blah blah blah
                }
                
                // Summon the rewind button for editing
                if element.element.createDisplays.count != 0 || element.element.disappearDisplays.count != 0 {
                    sharedEditNotifier.rewindButtonPresent = true
                }
            }
            
            
            //                    }
        }
        
        .gesture(
            DragGesture() // Have to add UI disappearing but not yet
                .onChanged { gesture in
                    
                    if !element.element.lock {
                        //                            let scaledWidth = element.element.size.width * CGFloat(element.element.scalar)
                        //                            let scaledHeight = element.element.size.height * CGFloat(element.element.scalar)
                        
                        let newX = gesture.location.x
                        let newY = gesture.location.y
                        element.element.totalOffset = CGPoint(x: newX, y: newY)
                        sharedEditNotifier.currentlyEdited = true
                        sharedEditNotifier.toDelete = sharedEditNotifier.trashCanFrame.contains(gesture.location)
                        sharedEditNotifier.editToggle()
                    }
                }
            
                .onEnded { gesture in
                    
                    if !element.element.lock {
                        if sharedEditNotifier.trashCanFrame.contains(gesture.location) {
                            deleteElement(elementsArray: elementsArray, id: element.element.id)
                        } 
                        
                        //                                element.element.startPosition = element.element.totalOffset
                        sharedEditNotifier.currentlyEdited = false
                        sharedEditNotifier.editToggle()
                    }
                })
        
        .gesture(
            SimultaneousGesture( // Rotating and Size change
                RotationGesture()
                    .updating($currentRotation) { value, state, _ in
                        
                        //                        var canSendRotation = true
                        //
                        //                        if rotationToSend + element.element.rotationDegrees == Angle(degrees: 0.0) {
                        //                            // Disable rotation sending temporarily
                        //                            canSendRotation = false
                        //
                        //                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        //                                            canSendRotation = true
                        //                                        }
                        //                        }
                        
                        if !element.element.lock {
                            state = value
                        }
                    }
                    .onEnded { value in
                        if !element.element.lock {
                            element.element.rotationDegrees += value
                        }
                    },
                MagnificationGesture()
                    .onChanged { amount in
                        if !element.element.lock {
                            currentAmount = amount - 1
                            sharedEditNotifier.currentlyEdited = true
                            sharedEditNotifier.editToggle()
                        }
                    }
                    .onEnded { amount in
                        if !element.element.lock {
                            element.element.scalar += currentAmount
                            currentAmount = 0
                            sharedEditNotifier.currentlyEdited = false
                            sharedEditNotifier.editToggle()
                        }
                        
                    }))
        .onChange(of: currentRotation) { newValue in
            
            if !element.element.lock {
                rotationToSend = currentRotation
            }
            
        }
        
        .onLongPressGesture(minimumDuration: 0.5, pressing: { inProgress in
                        // Called continuously while the long press is in progress

                        if inProgress {
                            // Start a timer when the long press begins
                            if timer == nil {
                                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                    // Your action after 0.5 seconds
                                    sharedEditNotifier.selectElement(element: element)
                                }
                            }
                        } else {
                            // Invalidate the timer when the long press ends
                            timer?.invalidate()
                            timer = nil
                        }
                    }, perform: {
                        // Perform the final action when the long press ends
                            print("Long press ended")
                            // Your final command here
                    })
    }
}

