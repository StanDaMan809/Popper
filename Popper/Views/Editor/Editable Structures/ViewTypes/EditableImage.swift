//
//  EditableImage.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI


class editableImg: Identifiable, ObservableObject {
    @Published var id: Int
    let imgSrc: UIImage
    @Published var currentShape: ClippableShape = .roundedrectangle
    @Published var position: CGSize = CGSize.zero
    @Published var size: CGSize // Image's true specs, to not be touched
    @Published var scalar: Double = 1.0
    @Published var transparency: Double = 1.0
    @Published var display: Bool
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var rotationDegrees: Angle = Angle.zero
    @Published var lock: Bool = false 
    @Published var linkOnClick: URL?
    @Published var soundOnClick: URL?
    let defaultDisplaySetting: Bool
    var startPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    init(id: Int, imgSrc: UIImage, size: CGSize, defaultDisplaySetting: Bool) {
        self.id = id
        self.display = defaultDisplaySetting
        self.imgSrc = imgSrc
        self.size = size
        self.defaultDisplaySetting = defaultDisplaySetting
    }
    
}

struct EditableImage: View {
    
    @ObservedObject var image: editableImg
    @ObservedObject var elementsArray: editorElementsArray
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
                        .clipShape(image.currentShape)
                        .frame(width: image.size.width, height: image.size.height)
                        .overlay(
                            Group {
                                if sharedEditNotifier.selectedElement?.element.id == image.id { Rectangle()
                                        .stroke(Color.black, lineWidth: 5)
                                }
                                
                                
                                if image.lock {
                                    elementLock(id: image.id)
                                }
                            }
                                
                        )
                        .rotationEffect(currentRotation + image.rotationDegrees)
                        .scaleEffect(image.scalar + currentAmount)
                        .offset(image.position)
                        .opacity(image.transparency)
                        .zIndex(sharedEditNotifier.textEdited() ? 0.0 : Double(image.id))
            }
        }
}

func imageAdd(imgSource: UIImage, elementsArray: editorElementsArray, sharedEditNotifier: SharedEditState) {
    
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
        
    }
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .image(editableImg(id: elementsArray.objectsCount, imgSrc: imgSource, size: CGSizeMake(imgSource.size.width, imgSource.size.height), defaultDisplaySetting: defaultDisplaySetting)))

    elementsArray.objectsCount += 1 // Increasing the number of objects counted for id purposes
//    sharedEditNotifier.editorDisplayed = .none
    
}


