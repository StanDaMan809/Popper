//
//  EditableImage.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

// these are the image classes
class editableImg: Identifiable, ObservableObject {
    @Published var id: Int
    let imgSrc: UIImage
    @Published var currentShape: ClippableShape = .rectangle
    @Published var totalOffset: CGPoint = CGPoint(x: 0, y: 0)
    @Published var size: [CGFloat] = [80, 40] // Image's true specs, to not be touched
    @Published var scalar: Double
    @Published var transparency: Double
    @Published var display: Bool
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var rotationDegrees: Angle = Angle.zero
    let defaultDisplaySetting: Bool
    var startPosition: CGPoint
    
    init(id: Int, imgSrc: UIImage, currentShape: ClippableShape, totalOffset: CGPoint, size: [CGFloat], scalar: Double, display: Bool, transparency: Double, defaultDisplaySetting: Bool) {
        self.id = id
        self.imgSrc = imgSrc
        self.currentShape = currentShape
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
    @State var currentAmount = 0.0
    @ObservedObject var sharedEditNotifier: SharedEditState
    @GestureState var currentRotation = Angle.zero
    
    var body: some View
        {
            if image.display
            {
                Image(uiImage: image.imgSrc)
                    // Image characteristics
                    .resizable()
                    .frame(width: image.size[0], height: image.size[1])
                    .clipShape(image.currentShape)
                    .rotationEffect(currentRotation + image.rotationDegrees)
                    .scaleEffect(image.scalar + currentAmount)
                    .position(image.totalOffset)
                    .opacity(image.transparency)
                    .zIndex(Double(image.id))
                    
                    // Image Gestures
                
                    .onTapGesture (count: 2)
                    {
                        image.currentShape = image.currentShape.next
                        
//                        switch image.currentShape {
//                        case .square:
//                            image.dimensionsForDisplay[1] = image.dimensionsForDisplay[0]
//                        case .rectangle:
//                            image.dimensionsForDisplay[0] = image.size[0]
//                            image.dimensionsForDisplay[1] = image.size[1]
//                        case .circle:
//                            image.dimensionsForDisplay[1] = image.dimensionsForDisplay[0]
//                        case .ellipse:
//                            image.dimensionsForDisplay[0] = image.size[0]
//                            image.dimensionsForDisplay[1] = image.size[1]
//                        case .capsule:
//                            image.dimensionsForDisplay[0] = image.size[0]
//                            image.dimensionsForDisplay[1] = image.size[1]
//                        case .triangle:
//                            image.dimensionsForDisplay[1] = image.dimensionsForDisplay[0]
//                        case .star:
//                            image.dimensionsForDisplay[1] = image.dimensionsForDisplay[0]
//                        }
//    
                    }
                
                    .onTapGesture
                    {
                        if sharedEditNotifier.editorDisplayed == .photoDisappear {
                            sharedEditNotifier.selectedImage?.disappearDisplays.append(self.image.id)
                            sharedEditNotifier.editorDisplayed = .none
                        }
                        
                        else
                        {
                                // Make all displays linked to this one appear!
                                for i in image.createDisplays
                                {
                                    print("Retrieving for \(i)...")
                                    if let itemToDisplay = elementsArray.elements[i] {
                                        itemToDisplay.element.display = true
                                    } else { }// else if textArray blah blah blah
                                }
                                
                                // Make all displays linked to this one disappear
                                for i in image.disappearDisplays
                                {
                                    if let itemToDisplay = elementsArray.elements[i] {
                                        itemToDisplay.element.display = false
                                    } // else if textArray blah blah blah
                                }
                            
                            // Summon the rewind button for editing
                            if image.createDisplays.count != 0 || image.disappearDisplays.count != 0 {
                                sharedEditNotifier.rewindButtonPresent = true
                            }
                        }
                        
                        
    //                    }
                    }
                
                    .gesture(
                        DragGesture() // Have to add UI disappearing but not yet
                            .onChanged { gesture in
                                let scaledWidth = image.size[0] * CGFloat(image.scalar)
                                let scaledHeight = image.size[1] * CGFloat(image.scalar)
                                let halfScaledWidth = scaledWidth / 2
                                let halfScaledHeight = scaledHeight / 2
                                let newX = gesture.location.x
                                let newY = gesture.location.y
                                image.totalOffset = CGPoint(x: newX, y: newY)
                                sharedEditNotifier.currentlyEdited = true
                                sharedEditNotifier.editToggle()
                                        }
                        
                            .onEnded { gesture in
                                image.startPosition = image.totalOffset
                                sharedEditNotifier.currentlyEdited = false
                                sharedEditNotifier.editToggle()
                            })
                
                    .gesture(
                    SimultaneousGesture( // Rotating and Size change
                            RotationGesture()
                            .updating($currentRotation) { value, state, _ in state = value
                                }
                            .onEnded { value in
                                image.rotationDegrees += value
                            },
                        MagnificationGesture()
                            .onChanged { amount in
                                currentAmount = amount - 1
                                sharedEditNotifier.currentlyEdited = true
                                sharedEditNotifier.editToggle()
                            }
                            .onEnded { amount in
                                image.scalar += currentAmount
                                currentAmount = 0
                                sharedEditNotifier.currentlyEdited = false
                                sharedEditNotifier.editToggle()
                                
                            }))
                
                    .gesture(LongPressGesture()
                        .onEnded{_ in
                    sharedEditNotifier.pressedButton = .imageEdit
                    sharedEditNotifier.selectImage(editableImg: image)
                            })
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
        self.size = editableImage.size.map { Double($0) } // For encoding
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
