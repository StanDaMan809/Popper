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
    
    @StateObject var sharedEditNotifier = SharedEditState()
    @StateObject var imgArray = imagesArray()
    @StateObject var imgAdded = imageAdded()
    @StateObject var txtArray = textsArray()
    
    
    var body: some View
    {
        @State var UIPrio = Double(imgArray.images.count + txtArray.texts.count + 1)
        @State var editTextPrio = UIPrio - 1
        @State var editbarPrio = UIPrio + 2
        @State var actionButtonPrio = UIPrio + 3
        
        ZStack
        {
            Background(sharedEditNotifier: sharedEditNotifier)
            EditorDisplays(sharedEditNotifier: sharedEditNotifier)
//            EditorBars()
//                .zIndex(editbarPrio)
            EditorTopUIButtons()
                .zIndex(UIPrio)
            PhotoEditButton(imgArray: imgArray, txtArray: txtArray, sharedEditNotifier: sharedEditNotifier, imgAdded: imgAdded)
                .zIndex(UIPrio)
                .hAlign(.trailing)
                .vAlign(.top)
                .offset(y: ((UIScreen.main.bounds.size.height - postHeight) / 2))
            bottomButtons(imgArray: imgArray, txtArray: txtArray, imgAdded: imgAdded, sharedEditNotifier: sharedEditNotifier)
                .zIndex(actionButtonPrio)
            
            editingArea()
            
            ForEach(imgArray.images.indices, id: \.self)
                { index in
                    EditableImage(image: imgArray.images[index],imgArray: imgArray, sharedEditNotifier: sharedEditNotifier)
                    
//                    if imgArray.images[index].createDisplays.images[0].display {
//                        ForEach(imgArray.images[index].createDisplays.images.indices, id: \.self) { index2 in
//                            EditableImage(image: imgArray.images[index].createDisplays.images[index2], sharedEditNotifier: sharedEditNotifier)
//                        }
//                    }
                }
            ForEach(txtArray.texts.indices, id: \.self)
            { index in
                EditableText(text: txtArray.texts[index], sharedEditNotifier: sharedEditNotifier, editPrio: editTextPrio)
            }
            if imgAdded.imgAdded {
                EditableImage(image: imgArray.images[imgAdded.addIndex], imgArray: imgArray, sharedEditNotifier: sharedEditNotifier)
            }
//            if let vicky = sharedEditNotifier.imageSubset {
//                ForEach(vicky.createDisplays.images.indices, id: \.self)
//                    { index in
//                        EditableImage(image: vicky.createDisplays.images[index], sharedEditNotifier: sharedEditNotifier)
//                    }
//            }
            
        }
    }
    
    struct editingArea: View {
        var body: some View {
            ZStack
                {
                    Color.black
                        .ignoresSafeArea(.all)
                    
                    Color.white
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: postHeight, maxHeight: postHeight, alignment: .center)
                }
        }
    }
    
}

struct Editor_Previews: PreviewProvider {
        static var previews: some View {
            Editor()
        }
    }

struct EditorTopUIButtons: View {
    var body: some View
    {
        Button(action: {
            print("okay")
            // This is supposed to prompt are you okay to leave ? which should be its own event tbh
        }, label: {
                Image(systemName: "arrow.backward")
        })
        .scaleEffect(1.5)
        .vAlign(.top)
        .tint(.white)
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


func imageAdd(imgSource: UIImage, imgArray: imagesArray, imgAdded: imageAdded, sharedEditNotifier: SharedEditState) {
    
    // if sharedEditState blah blah blah
    
    imgAdded.imgAdded = true
    
    if sharedEditNotifier.editorDisplayed == .photoAppear {
        
        if let currentImg = sharedEditNotifier.selectedImage
        {
            currentImg.createDisplays.append(imgArray.images.endIndex)
            imgArray.images.append(editableImg(id: imgArray.images.count, imgSrc: imgSource, currentShape: .rectangle, totalOffset: CGPoint(x: 0, y: 0), size: [CGFloat(imgSource.size.width), CGFloat(imgSource.size.height)], scalar: 1.0, display: false, transparency: 1))
            imgAdded.addIndex = imgArray.images.endIndex - 1
        }
        
    }

    else
    {
        imgArray.images.append(editableImg(id: imgArray.images.count, imgSrc: imgSource, currentShape: .rectangle, totalOffset: CGPoint(x: 150, y: 500), size: [CGFloat(imgSource.size.width), CGFloat(imgSource.size.height)], scalar: 1.0, display: true, transparency: 1))

        imgAdded.addIndex = imgArray.images.endIndex - 1
        
    }
    
    print(imgArray.images)
    imgAdded.imgAdded = false
    sharedEditNotifier.editorDisplayed = .none
    

}

class imageAdded: ObservableObject {
    @Published var imgAdded: Bool = false
    @Published var addIndex: Int = 0
    @Published var image: UIImage?
    @ObservedObject var imgArray = imagesArray()
    
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    @Binding var newImageChosen: Bool
    @ObservedObject var imgArray: imagesArray
    @ObservedObject var imgAdded: imageAdded
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
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
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showImagePicker = false
        }
        
    }
}

enum ClippableShape: Int {
    
    case rectangle
    case circle
    case ellipse
    case capsule
    
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
    }
    
    func imageSubset(editableImg: editableImg) {
        imageSubset = editableImg
    }
    
    func selectText(editableTxt: editableTxt) {
        selectedText = editableTxt
    }

}

enum EditorDisplayed: Int {
    
    case none
    case linkEditor
    case transparencySlider
    case photoAppear
    case photoDisappear
    
}

struct EditorDisplays: View {
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


    

