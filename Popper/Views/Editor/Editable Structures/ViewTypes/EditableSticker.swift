//
//  EditableSticker.swift
//  Popper
//
//  Created by Stanley Grullon on 11/16/23.
//

import SwiftUI
import SDWebImageSwiftUI

class editableStick: Identifiable, ObservableObject {
    @Published var id: Int
    let url: URL
    @Published var currentShape: ClippableShape = .rectangle
    @Published var totalOffset: CGPoint = CGPoint(x: 0, y: 0)
    @Published var scalar: Double
    @Published var transparency: Double
    @Published var display: Bool
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var rotationDegrees: Angle = Angle.zero
    @Published var lock: Bool = false
    @Published var linkOnClink: URL?
    @Published var soundOnClick: URL?
    let defaultDisplaySetting: Bool
    var startPosition: CGPoint
    
    init(id: Int, url: URL, totalOffset: CGPoint, scalar: Double, display: Bool, transparency: Double, defaultDisplaySetting: Bool) {
        self.id = id
        self.url = url
        self.totalOffset = totalOffset
        self.scalar = scalar
        self.startPosition = totalOffset // initialize startPosition by equating it to totalOffset
        self.display = display
        self.transparency = transparency
        self.defaultDisplaySetting = defaultDisplaySetting
    }
    
}

struct EditableSticker: View {
    
    @ObservedObject var sticker: editableStick
    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle
    
    var body: some View
        {
            if sticker.display
            {
                    AnimatedImage(url: sticker.url)
                    // Image characteristics
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(sticker.currentShape)
                        .overlay(
                            Group {
                                if sticker.lock {
                                    elementLock(id: sticker.id)
                                }
                            }
                        )
                        .rotationEffect(currentRotation + sticker.rotationDegrees)
                        .scaleEffect(sticker.scalar + currentAmount)
                        .position(sticker.totalOffset)
                        .opacity(sticker.transparency)
                        .zIndex(sharedEditNotifier.textEdited() ? 0.0 : Double(sticker.id))
            }
        }
}

func stickerAdd(url: URL, elementsArray: editorElementsArray, sharedEditNotifier: SharedEditState) {
    
    var display = true
    var defaultDisplaySetting = true
    
    if sharedEditNotifier.editorDisplayed == .photoAppear {
        
        if let currentElement = sharedEditNotifier.selectedElement
        {
            display = false // Set display to false so it doesn't show up until touched
            defaultDisplaySetting = false // set defaultDisplaySetting to false so the post will upload with display = false
            currentElement.element.createDisplays.append(elementsArray.objectsCount)
            print(currentElement.element.createDisplays)
        }
        
    }

    else
    {
        display = true
        
    }
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .sticker(editableStick(id: elementsArray.objectsCount, url: url, totalOffset: CGPoint(x: 150, y: 500), scalar: 1.0, display: display, transparency: 1, defaultDisplaySetting: defaultDisplaySetting)))

    elementsArray.objectsCount += 1 // Increasing the number of objects counted for id purposes
    sharedEditNotifier.editorDisplayed = .none
    print(elementsArray.elements.count)
    
}
