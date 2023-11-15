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
    @Published var totalOffset: CGPoint = CGPoint(x: 0, y: 0)
    @Published var size: CGSize // Image's true specs, to not be touched
    @Published var scalar: Double
    @Published var transparency: Double
    @Published var display: Bool
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var rotationDegrees: Angle = Angle.zero
    @Published var lock: Bool = false 
    @Published var linkOnClink: URL? 
    let defaultDisplaySetting: Bool
    var startPosition: CGPoint
    
    init(id: Int, imgSrc: UIImage, totalOffset: CGPoint, size: CGSize, scalar: Double, display: Bool, transparency: Double, defaultDisplaySetting: Bool) {
        self.id = id
        self.imgSrc = imgSrc
        self.totalOffset = totalOffset
        self.size = size
        self.scalar = scalar
        self.startPosition = totalOffset // initialize startPosition by equating it to totalOffset
        self.display = display
        self.transparency = transparency
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
                                if image.lock {
                                    elementLock(id: image.id)
                                }
                            }
                        )
                        .rotationEffect(currentRotation + image.rotationDegrees)
                        .scaleEffect(image.scalar + currentAmount)
                        .position(image.totalOffset)
                        .opacity(image.transparency)
                        .zIndex(Double(image.id))
            }
        }
}

struct EditableImageData: Codable, Equatable, Hashable {
    var id: Int
    var currentShape: Int
    var totalOffset: [Double]
    var size: [Double]
    var scalar: Double
    var transparency: Double
    var display: Bool
    var createDisplays: [Int] = []
    var disappearDisplays: [Int] = []
    var rotationDegrees: Double
    var imageURL: URL
    var imageReferenceID: String
    
    init(from editableImage: editableImg, imageURL: URL, imageReferenceID: String) {
        self.id = editableImage.id
        self.currentShape = editableImage.currentShape.rawValue // For encoding
        self.totalOffset = [Double(editableImage.totalOffset.x), Double(editableImage.totalOffset.y)] // For encoding
        self.size = [Double(editableImage.size.width), Double(editableImage.size.height)] // For encoding
        self.scalar = editableImage.scalar
        self.transparency = editableImage.transparency
        self.display = editableImage.defaultDisplaySetting // If user uploads a post that's already interacted with, it'll upload just fine
        self.createDisplays = editableImage.createDisplays
        self.disappearDisplays = editableImage.disappearDisplays
        self.rotationDegrees = editableImage.rotationDegrees.degrees
        self.imageURL = imageURL
        self.imageReferenceID = imageReferenceID
    }
    
    // There may be a bug involving the rotationDegrees not encoding from the posts; I deleted the posts just to be safe, but know that if there’s an issue and it says no posts showing, it’s because I added the rotationDegrees field to images when it didn’t have that before and that might cause it to not load properly
}

func imageAdd(imgSource: UIImage, elementsArray: editorElementsArray, sharedEditNotifier: SharedEditState) {
    
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
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .image(editableImg(id: elementsArray.objectsCount, imgSrc: imgSource, totalOffset: CGPoint(x: 150, y: 500), size: CGSizeMake(imgSource.size.width, imgSource.size.height), scalar: 1.0, display: display, transparency: 1, defaultDisplaySetting: defaultDisplaySetting)))

    elementsArray.objectsCount += 1 // Increasing the number of objects counted for id purposes
    sharedEditNotifier.editorDisplayed = .none
    
}


