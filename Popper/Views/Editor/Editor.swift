//
//  Editor.swift
//  Popper
//
//  Created by Stanley Grullon on 4/6/23.
//

import SwiftUI
import PhotosUI
import AVFoundation

let postHeight = CGFloat(530)

struct Editor: View {
    // Used for identifying objects, even after deletion. This will likely have to move when Drafts are introduced.
    @Binding var isEditorActive: Bool
    @StateObject var sharedEditNotifier = SharedEditState()
    
    // For foreground
    @StateObject var elementsArray = editorElementsArray()
    
    // For background
    @StateObject var bgElementsArray = editorElementsArray()
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View
    {
        if sharedEditNotifier.backgroundEdit {
            EditorView(parent: self, elementsArray: bgElementsArray)
        } else {
            EditorView(parent: self, elementsArray: elementsArray)
        }
        
    }
    
    struct EditorView: View { // View redeclared to allow for background editing
        
        let parent: Editor
        @ObservedObject var elementsArray: editorElementsArray
        
        
        var body: some View {
            @State var UIPrio = Double(parent.sharedEditNotifier.objectsCount + 1)
            @State var editTextPrio = UIPrio - 1
            @State var editbarPrio = UIPrio + 2
            @State var actionButtonPrio = UIPrio + 3
            
            ZStack
            {
                VStack
                {
                    
                    // Back Button
                    
                    Button(action: {
                        parent.isEditorActive = false
                    }, label: {
                        Image(systemName: "arrow.backward")
                    })
                    .opacity(parent.sharedEditNotifier.buttonDim)
                    .scaleEffect(1.5)
                    .tint(.black)
                    .hAlign(.leading)
                    .padding()
                    
                    // Side Buttons
                    
                    HStack(alignment: .top){
                        if parent.sharedEditNotifier.rewindButtonPresent {
                            RewindButton(elementsArray: elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                        }
                        
                        Spacer()
                        
                        SideButtons(elementsArray: elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                    }
                    
                    Spacer()
                    
                    bottomButtons(isEditorActive: parent.$isEditorActive, elementsArray: elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                        .zIndex(Double(parent.sharedEditNotifier.objectsCount + 1))
                    
                    
                }
                .zIndex(Double(parent.sharedEditNotifier.objectsCount + 2))
                
                
                if parent.sharedEditNotifier.backgroundEdit != true {
                    Background(sharedEditNotifier: parent.sharedEditNotifier, elementsArray: parent.bgElementsArray, editTextPrio: editTextPrio)
                        .zIndex(-1)
                }
                
                ZStack {
                    ForEach(elementsArray.elements.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                        if let itemToDisplay = elementsArray.elements[key] {
                            EditableElement(element: itemToDisplay, elementsArray: elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                            
                        }
                        
                    }
                }
                .zIndex(Double(parent.sharedEditNotifier.objectsCount))
                
            }
            
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var videoURL: URL?
    @Binding var showImagePicker: Bool
    @Binding var showCamera: Bool
    @Binding var newImageChosen: Bool
    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    let sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        if sharedEditNotifier.backgroundEdit == false {
            imagePicker.mediaTypes = ["public.image", "public.movie"]
        }
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
                    imageAdd(imgSource: originalImage, elementsArray: parent.elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                }
                else
                {
                    if let downsampledImage = originalImage.downsample(to: targetSize) {
                        imageAdd(imgSource: downsampledImage, elementsArray: parent.elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                    }
                }
                
                
            }
            else if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                let asset = AVURLAsset(url: videoUrl, options: nil)
                let tracks = asset.tracks(withMediaType: .video)
                
                if let videoTrack = tracks.first {
                    let videoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
                    // Correct the size if it's negative due to the transform
                    let correctedSize = CGSize(width: abs(videoSize.width), height: abs(videoSize.height))
                    
                    // Use screenWidth and maxHeight to calculate aspect ratio and targetSize if needed
                    let screenWidth = UIScreen.main.bounds.width
                    let maxHeight: CGFloat = UIScreen.main.bounds.height
                    let aspectRatio = correctedSize.width / correctedSize.height
                    let targetHeight = min(maxHeight, screenWidth / aspectRatio)
                    let targetSize = CGSize(width: screenWidth, height: targetHeight)
                    
                    // You can now use this size information as you need, for instance:
                    videoAdd(vidURL: videoUrl, size: targetSize, elementsArray: parent.elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
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
    case shapeEdit
    case stickerEdit
    case elementAppear
    
}

enum ClippableShape: Int {
    
    case square
    case roundedsquare
    case rectangle
    case roundedrectangle
    case circle
    case ellipse
    case capsule
    case triangle
    case star
    
    var next: ClippableShape {
        ClippableShape(rawValue: rawValue + 1) ?? .square
    }
}

struct ClippableShapeViewModifier: ViewModifier {
    
    private let clippableShape: ClippableShape
    
    init(clippableShape: ClippableShape) {
        self.clippableShape = clippableShape
    }
    
    @ViewBuilder func body(content: Content) -> some View {
        switch clippableShape {
        case .square:
            content.clipShape(Square())
        case .roundedsquare:
            content.clipShape(RoundedSquare(cornerRadius: 10))
        case .rectangle:
            content.clipShape(Rectangle())
        case .roundedrectangle:
            content.clipShape(RoundedRectangle(cornerRadius: 10))
        case .circle:
            content.clipShape(Circle())
        case .ellipse:
            content.clipShape(Ellipse())
        case .capsule:
            content.clipShape(Capsule())
        case .triangle:
            content.clipShape(Triangle())
        case .star:
            content.clipShape(Star())
        }
    }
}

extension View {
    func clipShape(_ clippableShape: ClippableShape) -> some View {
        self.modifier(ClippableShapeViewModifier(clippableShape: clippableShape))
    }
}

func shapeForClippableShape(shape: ClippableShape) -> some View {
    switch shape {
    case .square:
        return AnyView(Square())
    case .roundedsquare:
        return AnyView(RoundedSquare(cornerRadius: 10))
    case .rectangle:
        return AnyView(Rectangle())
    case .roundedrectangle:
        return AnyView(RoundedRectangle(cornerRadius: 10))
    case .circle:
        return AnyView(Circle())
    case .ellipse:
        return AnyView(Ellipse())
    case .capsule:
        return AnyView(Capsule())
    case .triangle:
        return AnyView(Triangle())
    case .star:
        return AnyView(Star())
    }
}

class SharedEditState: ObservableObject {
    
    @Published var currentlyEdited: Bool = false
    @Published var buttonDim: Double = 1
    @Published var disabled: Bool = false
    @Published var selectedElement: editorElement?
    @Published var editorDisplayed = EditorDisplayed.none
    @Published var pressedButton: UIButtonPress = .noButton
    @Published var rewindButtonPresent: Bool = false
    @Published var objectsCount: Int = 0
    @Published var backgroundEdit: Bool = false
    @Published var bgObjectsCount: Int = 0
    @Published var delete: Bool = false
    @Published var trashCanFrame = CGRect.zero
    @Published var toDelete = false
    
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
    
    
    func selectElement(element: editorElement) {
        selectedElement = element
        
        switch element.element {
        case .image:
            pressedButton = .imageEdit
        case .video:
            pressedButton = .imageEdit // this will be changed if i decide to implement video-specific changes later... but im not quite sure ab that
        case .text:
            pressedButton = .textEdit
        case .shape:
            pressedButton = .shapeEdit
        case .sticker:
            pressedButton = .stickerEdit
            
        }
    }
    
    func restoreDefaults() { // For when you need to make sure that everything is fine
        deselectAll()
        editorDisplayed = .none
        pressedButton = .noButton
    }
    
    func deselectAll() {
        selectedElement = nil
    }
    
    
    
    enum EditorDisplayed: Int {
        
        case none
        case linkEditor
        case transparencySlider
        case photoAppear
        case elementDisappear
        case colorPickerText
        case colorPickerTextBG
        case colorPickerShape
        case fontPicker
        case voiceRecorder
    }
    
}

func deleteElement(elementsArray: editorElementsArray, id: Int) {
    
    elementsArray.elements.removeValue(forKey: id)
}

// image select settings
// Rotation
// Add link
// Crop



