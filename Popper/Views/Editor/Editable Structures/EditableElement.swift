//
//  EditableElement.swift
//  Popper
//
//  Created by Stanley Grullon on 11/13/23.
//

//import SwiftUI
//
//struct EditableElement: View {
//    
//    @ObservedObject var element: editorElement
//    @ObservedObject var elementsArray: editorElementsArray
//    @State var currentAmount = 0.0
//    @ObservedObject var sharedEditNotifier: SharedEditState
//    @GestureState var currentRotation = Angle.zero
//    
//    var body: some View {
//        switch element.element {
//        case .image(let editableImage):
//                
//            EditableImage(image: editableImage, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
//            
//        case .video(let editableVid):
//            
//            EditableVideo(video: editableVid, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
//            
//        case .text(let editableTxt):
//            
//            EditableText(text: editableTxt, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
//            
//        case .shape(let editableShp):
//            
//            EditableShape(shape: editableShp, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
//        }
//            .onTapGesture (count: 2)
//            {
//                element.element.data.currentShape = element.element.data.currentShape.next
//                
//            }
//        
//            .onTapGesture
//            {
//                if sharedEditNotifier.editorDisplayed == .photoDisappear {
//                    sharedEditNotifier.selectedImage?.disappearDisplays.append(self.element.element.data.id)
//                    sharedEditNotifier.editorDisplayed = .none
//                }
//                
//                else
//                {
//                        // Make all displays linked to this one appear!
//                        for i in element.element.data.createDisplays
//                        {
//                            print("Retrieving for \(i)...")
//                            if let itemToDisplay = elementsArray.elements[i] {
//                                itemToDisplay.element.display = true
//                            } else { }// else if textArray blah blah blah
//                        }
//                        
//                        // Make all displays linked to this one disappear
//                        for i in element.element.data.disappearDisplays
//                        {
//                            if let itemToDisplay = elementsArray.elements[i] {
//                                itemToDisplay.element.display = false
//                            } // else if textArray blah blah blah
//                        }
//                    
//                    // Summon the rewind button for editing
//                    if element.element.data.createDisplays.count != 0 || element.element.data.disappearDisplays.count != 0 {
//                        sharedEditNotifier.rewindButtonPresent = true
//                    }
//                }
//                
//                
////                    }
//            }
//        
//            .gesture(
//                DragGesture() // Have to add UI disappearing but not yet
//                    .onChanged { gesture in
//                        
//                        let scaledWidth = element.element.data.size[0] * CGFloat(element.element.data.scalar)
//                        let scaledHeight = element.element.data.size[1] * CGFloat(element.element.data.scalar)
//
//                        let newX = gesture.location.x
//                        let newY = gesture.location.y
//                        element.element.data.totalOffset = CGPoint(x: newX, y: newY)
//                        sharedEditNotifier.currentlyEdited = true
//                        sharedEditNotifier.toDelete = sharedEditNotifier.trashCanFrame.contains(gesture.location)
//                        sharedEditNotifier.editToggle()
//                    }
//                
//                    .onEnded { gesture in
//                        
//                        if sharedEditNotifier.trashCanFrame.contains(gesture.location) {
//                            deleteElement(elementsArray: elementsArray, id: element.element.data.id)
//                        } else {
//                            element.element.data.startPosition = element.element.data.totalOffset
//                        }
//                        
////                                element.element.data.startPosition = element.element.data.totalOffset
//                        sharedEditNotifier.currentlyEdited = false
//                        sharedEditNotifier.editToggle()
//                    })
//        
//            .gesture(
//            SimultaneousGesture( // Rotating and Size change
//                    RotationGesture()
//                    .updating($currentRotation) { value, state, _ in state = value
//                        }
//                    .onEnded { value in
//                        element.element.data.rotationDegrees += value
//                    },
//                MagnificationGesture()
//                    .onChanged { amount in
//                        currentAmount = amount - 1
//                        sharedEditNotifier.currentlyEdited = true
//                        sharedEditNotifier.editToggle()
//                    }
//                    .onEnded { amount in
//                        element.element.data.scalar += currentAmount
//                        currentAmount = 0
//                        sharedEditNotifier.currentlyEdited = false
//                        sharedEditNotifier.editToggle()
//                        
//                    }))
//        
//            .gesture(LongPressGesture()
//                .onEnded{_ in
//            sharedEditNotifier.pressedButton = .element.element.dataEdit
//            sharedEditNotifier.selectImage(editableImg: element.element.data)
//                    })
//    }
//}

