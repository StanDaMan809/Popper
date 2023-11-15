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
    
    init(id: Int, imgSrc: UIImage, currentShape: ClippableShape, totalOffset: CGPoint, size: CGSize, scalar: Double, display: Bool, transparency: Double, defaultDisplaySetting: Bool) {
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
                        
                        
//                        Image(systemName: "lock.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .foregroundStyle(Color.white)
//                            .frame(width: 18, height: 18) // Adjust the size as needed
//                            .rotationEffect(currentRotation + image.rotationDegrees) // Apply the same rotation
//                            .scaleEffect(image.scalar + currentAmount)
//                            .position(x: image.totalOffset.x + image.size.width/2 - 10, y: image.totalOffset.y - image.size.height/2 + 10)
//
//                    }
                
                    
                
            
                    // Image Gestures
                
//                    .onTapGesture (count: 2)
//                    {
//                        image.currentShape = image.currentShape.next
//                        
//                    }
//                
//                    .onTapGesture
//                    {
//                        if sharedEditNotifier.editorDisplayed == .photoDisappear {
//                            sharedEditNotifier.selectedImage?.disappearDisplays.append(self.image.id)
//                            sharedEditNotifier.editorDisplayed = .none
//                        }
//                        
//                        else
//                        {
//                                // Make all displays linked to this one appear!
//                                for i in image.createDisplays
//                                {
//                                    print("Retrieving for \(i)...")
//                                    if let itemToDisplay = elementsArray.elements[i] {
//                                        itemToDisplay.element.display = true
//                                    } else { }// else if textArray blah blah blah
//                                }
//                                
//                                // Make all displays linked to this one disappear
//                                for i in image.disappearDisplays
//                                {
//                                    if let itemToDisplay = elementsArray.elements[i] {
//                                        itemToDisplay.element.display = false
//                                    } // else if textArray blah blah blah
//                                }
//                            
//                            // Summon the rewind button for editing
//                            if image.createDisplays.count != 0 || image.disappearDisplays.count != 0 {
//                                sharedEditNotifier.rewindButtonPresent = true
//                            }
//                        }
//                        
//                        
//    //                    }
//                    }
//                
//                    .gesture(
//                        DragGesture() // Have to add UI disappearing but not yet
//                            .onChanged { gesture in
//                                
//                                let scaledWidth = image.size.width * CGFloat(image.scalar)
//                                let scaledHeight = image.size.height * CGFloat(image.scalar)
//
//                                let newX = gesture.location.x
//                                let newY = gesture.location.y
//                                image.totalOffset = CGPoint(x: newX, y: newY)
//                                sharedEditNotifier.currentlyEdited = true
//                                sharedEditNotifier.toDelete = sharedEditNotifier.trashCanFrame.contains(gesture.location)
//                                sharedEditNotifier.editToggle()
//                            }
//                        
//                            .onEnded { gesture in
//                                
//                                if sharedEditNotifier.trashCanFrame.contains(gesture.location) {
//                                    deleteElement(elementsArray: elementsArray, id: image.id)
//                                } else {
//                                    image.startPosition = image.totalOffset
//                                }
//                                
////                                image.startPosition = image.totalOffset
//                                sharedEditNotifier.currentlyEdited = false
//                                sharedEditNotifier.editToggle()
//                            })
//                
//                    .gesture(
//                    SimultaneousGesture( // Rotating and Size change
//                            RotationGesture()
//                            .updating($currentRotation) { value, state, _ in state = value
//                                }
//                            .onEnded { value in
//                                image.rotationDegrees += value
//                            },
//                        MagnificationGesture()
//                            .onChanged { amount in
//                                currentAmount = amount - 1
//                                sharedEditNotifier.currentlyEdited = true
//                                sharedEditNotifier.editToggle()
//                            }
//                            .onEnded { amount in
//                                image.scalar += currentAmount
//                                currentAmount = 0
//                                sharedEditNotifier.currentlyEdited = false
//                                sharedEditNotifier.editToggle()
//                                
//                            }))
//                
//                    .gesture(LongPressGesture()
//                        .onEnded{_ in
//                    sharedEditNotifier.pressedButton = .imageEdit
//                    sharedEditNotifier.selectImage(editableImg: image)
//                            })
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
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .image(editableImg(id: elementsArray.objectsCount, imgSrc: imgSource, currentShape: .rectangle, totalOffset: CGPoint(x: 150, y: 500), size: CGSizeMake(imgSource.size.width, imgSource.size.height), scalar: 1.0, display: display, transparency: 1, defaultDisplaySetting: defaultDisplaySetting)))

    elementsArray.objectsCount += 1 // Increasing the number of objects counted for id purposes
    sharedEditNotifier.editorDisplayed = .none
    
}


