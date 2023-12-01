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
    @Published var position: CGSize = CGSize.zero
    @Published var scalar: Double = 1.0
    @Published var transparency: Double = 1.0
    @Published var display: Bool
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var rotationDegrees: Angle = Angle.zero
    @Published var lock: Bool = false
    @Published var linkOnClink: URL?
    @Published var soundOnClick: URL?
    let defaultDisplaySetting: Bool
    var startPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    init(id: Int, url: URL, defaultDisplaySetting: Bool) {
        self.id = id
        self.url = url
        self.display = defaultDisplaySetting
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
                        .offset(sticker.position)
                        .opacity(sticker.transparency)
                        .zIndex(sharedEditNotifier.textEdited() ? 0.0 : Double(sticker.id))
            }
        }
}

func stickerAdd(url: URL, elementsArray: editorElementsArray, sharedEditNotifier: SharedEditState) {
    
    var defaultDisplaySetting = true
    
    if sharedEditNotifier.editorDisplayed == .photoAppear {
        
        if let currentElement = sharedEditNotifier.selectedElement
        {
            defaultDisplaySetting = false // set defaultDisplaySetting to false so the post will upload with display = false
            currentElement.element.createDisplays.append(elementsArray.objectsCount)
            print(currentElement.element.createDisplays)
        }
        
    }
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .sticker(editableStick(id: elementsArray.objectsCount, url: url, defaultDisplaySetting: defaultDisplaySetting)))

    elementsArray.objectsCount += 1 // Increasing the number of objects counted for id purposes
    sharedEditNotifier.editorDisplayed = .none
    print(elementsArray.elements.count)
    
}
