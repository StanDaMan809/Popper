//
//  EditablePoll.swift
//  Popper
//
//  Created by Stanley Grullon on 11/17/23.
//

import SwiftUI

class editablePoll: Identifiable, ObservableObject {
    @Published var id: Int
    @Published var totalOffset: CGPoint = CGPoint(x: 0, y: 0)
    @Published var question: String = ""
    @Published var responses: [String] = ["", "", "", ""]
    @Published var topColor: Color = Color.gray
    @Published var bottomColor: Color = Color.black
    @Published var buttonColor: Color = Color.white
    @Published var scalar: Double = 1
    @Published var transparency: Double = 1
    @Published var display: Bool
    @Published var rotationDegrees: Angle = Angle.zero
    @Published var lock: Bool = false
    @Published var linkOnClink: URL?
    @Published var soundOnClick: URL?
    let defaultDisplaySetting: Bool
    var startPosition: CGPoint
    
    init(id: Int, totalOffset: CGPoint, defaultDisplaySetting: Bool) {
        self.id = id
        self.totalOffset = totalOffset
        self.startPosition = totalOffset // initialize startPosition by equating it to totalOffset
        self.display = defaultDisplaySetting
        self.defaultDisplaySetting = defaultDisplaySetting
    }
    
}

struct EditablePoll: View {
    
    @ObservedObject var poll: editablePoll
    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    
    var body: some View {
        if poll.display {
            PollView(poll: poll, sharedEditNotifier: sharedEditNotifier)
            // Image characteristics
                .overlay(
                    Group {
                        if poll.lock {
                            elementLock(id: poll.id, small: true)
                        }
                    }
                )
                .rotationEffect(currentRotation + poll.rotationDegrees)
                .scaleEffect(poll.scalar + currentAmount)
                .position(poll.totalOffset)
                .opacity(poll.transparency)
                .zIndex(sharedEditNotifier.textEdited() ? 0.0 : Double(poll.id))
                
        }
    }
}

func pollAdd(elementsArray: editorElementsArray, sharedEditNotifier: SharedEditState) {
    
    var defaultDisplaySetting = true
    
    if sharedEditNotifier.editorDisplayed == .photoAppear {
        
        if let currentElement = sharedEditNotifier.selectedElement
        {
            defaultDisplaySetting = false // set defaultDisplaySetting to false so the post will upload with display = false
            currentElement.element.createDisplays.append(elementsArray.objectsCount)
            print(currentElement.element.createDisplays)
        }
        
    }

    else
    {
        defaultDisplaySetting = true
        
    }
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .poll(editablePoll(id: elementsArray.objectsCount, totalOffset: CGPoint(x: 150, y: 500), defaultDisplaySetting: defaultDisplaySetting)))

    elementsArray.objectsCount += 1 // Increasing the number of objects counted for id purposes
    sharedEditNotifier.editorDisplayed = .none
    
}
