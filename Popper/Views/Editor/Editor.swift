//
//  Editor.swift
//  Popper
//
//  Created by Stanley Grullon on 4/6/23.
//

import SwiftUI
import PhotosUI

let postHeight = CGFloat(530)

struct Editor: View {
    // Used for identifying objects, even after deletion. This will likely have to move when Drafts are introduced.
    @Binding var isEditorActive: Bool
    @StateObject var sharedEditNotifier = SharedEditState()
    @StateObject var imgArray = imagesArray()
    @StateObject var imgAdded = imageAdded()
    @StateObject var txtArray = textsArray()
    @StateObject var shpArray = shapesArray()
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View
    {
        @State var UIPrio = Double(imgArray.images.count + txtArray.texts.count + shpArray.shapes.count + 1)
        @State var editTextPrio = UIPrio - 1
        @State var editbarPrio = UIPrio + 2
        @State var actionButtonPrio = UIPrio + 3
        
        ZStack
        {
            
            VStack
            {
                
                // Back Button
                
                Button(action: {
                    isEditorActive = false
                }, label: {
                        Image(systemName: "arrow.backward")
                })
                .scaleEffect(1.5)
                .tint(.black)
                .hAlign(.leading)
                .padding()
                
                // Side Buttons
                
                PhotoEditButton(imgArray: imgArray, txtArray: txtArray, shpArray: shpArray, sharedEditNotifier: sharedEditNotifier, imgAdded: imgAdded)
                    
            }
            .zIndex(UIPrio)
            
            Background(sharedEditNotifier: sharedEditNotifier)
            EditorDisplays(sharedEditNotifier: sharedEditNotifier)
//            EditorBars()
//                .zIndex(editbarPrio)
            
            bottomButtons(isEditorActive: $isEditorActive, imgArray: imgArray, txtArray: txtArray, imgAdded: imgAdded, sharedEditNotifier: sharedEditNotifier)
                .zIndex(actionButtonPrio)
            
            ForEach(imgArray.images.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                    if let itemToDisplay = imgArray.images[key] {
                        EditableImage(image: itemToDisplay, imgArray: imgArray, sharedEditNotifier: sharedEditNotifier)
                    }
            }
//                    if imgArray.images[index].createDisplays.images[0].display {
//                        ForEach(imgArray.images[index].createDisplays.images.indices, id: \.self) { index2 in
//                            EditableImage(image: imgArray.images[index].createDisplays.images[index2], sharedEditNotifier: sharedEditNotifier)
//                        }
//                    }
               
            ForEach(txtArray.texts.sorted(by: {$0.key < $1.key}), id: \.key)
            { key, value in
                if let textToDisplay = txtArray.texts[key] {
                    EditableText(text: textToDisplay, sharedEditNotifier: sharedEditNotifier, editPrio: editTextPrio)
                }
            }
            
            ForEach(shpArray.shapes.sorted(by: {$0.key < $1.key}), id: \.key)
            { key, value in
                if let shapeToDisplay = shpArray.shapes[key] {
                    EditableShape(shape: shapeToDisplay, sharedEditNotifier: sharedEditNotifier)
                }
            }
            
//            if imgAdded.imgAdded, let imageToDisplay = imgArray.images[sharedEditNotifier.objectsCount] {
//                EditableImage(image: imageToDisplay, imgArray: imgArray, sharedEditNotifier: sharedEditNotifier)
//            }
            
            
        }
    }
    
}

func imageAdd(imgSource: UIImage, imgArray: imagesArray, imgAdded: imageAdded, sharedEditNotifier: SharedEditState) {
    
    var display = true
    var defaultDisplaySetting = true
    
    imgAdded.imgAdded = true
    
    if sharedEditNotifier.editorDisplayed == .photoAppear {
        
        if let currentImg = sharedEditNotifier.selectedImage
        {
            display = false // Set display to false so it doesn't show up until touched
            defaultDisplaySetting = false // set defaultDisplaySetting to false so the post will upload with display = false
            currentImg.createDisplays.append(sharedEditNotifier.objectsCount)
            print(currentImg.createDisplays)
        }
        
    }

    else
    {
        display = true
        
    }
    
    imgArray.images[sharedEditNotifier.objectsCount] = editableImg(id: sharedEditNotifier.objectsCount, imgSrc: imgSource, currentShape: .rectangle, totalOffset: CGPoint(x: 150, y: 500), size: [CGFloat(imgSource.size.width), CGFloat(imgSource.size.height)], scalar: 1.0, display: display, transparency: 1, defaultDisplaySetting: defaultDisplaySetting)

    imgAdded.addIndex = sharedEditNotifier.objectsCount
    sharedEditNotifier.objectsCount += 1 // Increasing the number of objects counted for id purposes
    print(imgArray.images) // Bugchecking
    imgAdded.imgAdded = false
    sharedEditNotifier.editorDisplayed = .none
    
}

func textAdd(textArray: textsArray, sharedEditNotifier: SharedEditState) {
    
    textArray.texts[sharedEditNotifier.objectsCount] = editableTxt(id: sharedEditNotifier.objectsCount, message: "Lorem Ipsum", totalOffset: CGPoint(x: 200, y: 400), size: [80, 80], scalar: 1.0, rotationDegrees: 0.0)
    
    sharedEditNotifier.objectsCount += 1
}

struct ImagePickerView: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    @Binding var showCamera: Bool
    @Binding var newImageChosen: Bool
    @ObservedObject var imgArray: imagesArray
    @ObservedObject var imgAdded: imageAdded
    @ObservedObject var sharedEditNotifier: SharedEditState
    let sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // nothing to update here
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let screenWidth = UIScreen.main.bounds.width
                let maxHeight: CGFloat = postHeight

                let aspectRatio = originalImage.size.width / originalImage.size.height
                let targetHeight = min(maxHeight, screenWidth / aspectRatio)
                let targetSize = CGSize(width: screenWidth, height: targetHeight)
                
                if originalImage.size.width < screenWidth && originalImage.size.height < postHeight {
                    imageAdd(imgSource: originalImage, imgArray: parent.imgArray, imgAdded: parent.imgAdded, sharedEditNotifier: parent.sharedEditNotifier)
                }
                else
                {
                    if let downsampledImage = originalImage.downsample(to: targetSize) {
                        imageAdd(imgSource: downsampledImage, imgArray: parent.imgArray, imgAdded: parent.imgAdded, sharedEditNotifier: parent.sharedEditNotifier)
                }
                }
            }
            parent.showImagePicker = false
            parent.showCamera = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showImagePicker = false
            parent.showCamera = false
        }
        
    }
}


struct EditorTopUIButtons: View {

    var body: some View
    {
        Button(action: {
            print("hey")
        }, label: {
                Image(systemName: "arrow.backward")
        })
        .scaleEffect(1.5)
        .tint(.black)
        .hAlign(.leading)
        .padding()
    }
}


enum UIButtonPress {
    
    case noButton
    case imageEdit
    case bgButton
    case extrasButton
    case txtButton
    case disappeared
    case textEdit

}

class imageAdded: ObservableObject {
    @Published var imgAdded: Bool = false
    @Published var addIndex: Int = 0
    @Published var image: UIImage?
    @ObservedObject var imgArray = imagesArray()
    
}

enum ClippableShape: Int {
    
    case rectangle
    case circle
    case ellipse
    case capsule
    case triangle
    
    var next: ClippableShape {
        ClippableShape(rawValue: rawValue + 1) ?? .rectangle
    }
}

struct ClippableShapeViewModifier: ViewModifier {
    
    private let clippableShape: ClippableShape
    
    init(clippableShape: ClippableShape) {
        self.clippableShape = clippableShape
    }
    
    @ViewBuilder func body(content: Content) -> some View {
        switch clippableShape {
        case .rectangle:
            content.clipShape(Rectangle())
        case .circle:
            content.clipShape(Circle())
        case .ellipse:
            content.clipShape(Ellipse())
        case .capsule:
            content.clipShape(Capsule())
        case .triangle:
            content.clipShape(Triangle())
        }
    }
}

extension View {
    func clipShape(_ clippableShape: ClippableShape) -> some View {
        self.modifier(ClippableShapeViewModifier(clippableShape: clippableShape))
    }
}

class SharedEditState: ObservableObject {
    @Published var currentlyEdited: Bool = false
    @Published var buttonDim: Double = 1
    @Published var disabled: Bool = false
    @Published var selectedImage: editableImg?
    @Published var selectedText: editableTxt?
    @Published var editorDisplayed = EditorDisplayed.none
    @Published var pressedButton: UIButtonPress = .noButton
    @Published var imageSubset: editableImg?
    @Published var undoButtonPresent: Bool = false
    @Published var objectsCount: Int = 0
    @Published var delete: Bool = false
    
    func editToggle()
    {
        if self.currentlyEdited
            {
                self.buttonDim = 0.4
                self.disabled = true
            }
        else
        {
            self.buttonDim = 1
            self.disabled = false
        }
    }
    
    func selectImage(editableImg: editableImg) {
        selectedImage = editableImg
        selectedText = nil
    }
    
    func imageSubset(editableImg: editableImg) {
        imageSubset = editableImg
    }
    
    func selectText(editableTxt: editableTxt) {
        selectedText = editableTxt
        selectedImage = nil
    }
    
    enum EditorDisplayed: Int {
        
        case none
        case linkEditor
        case transparencySlider
        case photoAppear
        case photoDisappear
        case colorPickerText
        case colorPickerShape
        
    }

}



struct EditorDisplays: View { // Change whatever function calling this to only display this IF the variable is there. Jesus. 
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View {
        VStack
        {
            if sharedEditNotifier.editorDisplayed == .transparencySlider
            {
                if let currentlySelected = sharedEditNotifier.selectedImage
                {
                    TransparencySlider(transparency: Binding(get: { currentlySelected.transparency }, set: { currentlySelected.transparency = $0 }))
                }
            }
        }
    }
}

struct TransparencySlider: View {
    @Binding var transparency: Double
    
    var body: some View {
        HStack
        {
                Slider(value: $transparency, in: 0.01...1)
        }
        .scaleEffect(0.80)
        .offset(y: 250)
    }
}

struct RotationSlider: View {
    @Binding var angle: Double
    
    var body: some View {
        HStack
        {
            Slider(value: $angle, in: 0.0...360.0)
        }
        .scaleEffect(0.80)
        .offset(y: 250)
    }
}





// just have the entire editableImg have a visibility thing ig

// literally how the fuck do I do this...
    // I can either make an array of arrays of editableImages, that, when their parent element is pressed, calls the EditableImage() EditableText() EditableVideo() etc functions
        // ostensible from the first explanation
            // Honestly this one is prolly cleaner code?
    // Have "appeared" as a boolean on all editableImages and whatNot; the view exists when viewed = true...
        // Then the onTapEffect can toggle() all the "child views" which will simultaneously make what needs to appear / disappear happen instead of making this shit so complicated (which is even better than the first thing too because im thinking if it happens on PRESS then it will just make infinite versions of the thing depending on how many times people press the thing)
        // This one makes the "deletion" command easy to work with, though.
        // okay so for image create:
            // Add a few things:
                // 1. New state to the EditableImg() class; "appeared" (boolean)
                // 2. If sharedEditNotifier.editor == .photoAppear {} / else {} to .photoAdd
                // 3. EditableImage() view structure is gated behind if appeared
            // SharedEditState whatever is set to .photoAppear
            // This then prompts you to create an image
            // When you create the image, photoAdd() is called
            // photoAdd() recognizes that sharedEditNotifier = .photoAppear... this will then make a create with appeared = false
            // sharedEditNotifier.editor == .none
            // now as for the onTapGesture... (programming them to be linked)
                // perhaps photoAdd() can return the index of the created image to the editableImage (YESSS!!!!), that way the .onTapGesture can change them
                // This can be an array called "childviews" which will then go "forall" or whatever the command is : "forall in childviews" {childviews.appear.toggle()} so good

// image select settings
    // Rotation
    // Add link
    // Crop


    

