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
    
//    // For foreground
//    @StateObject var elementsArray = editorElementsArray()
//    
//    // For background
//    @StateObject var bgElementsArray = editorElementsArray()
    
    @State var elementsArray: [String : editableElement] = [:]
    @State var bgElementsArray: [String : editableElement] = [:]
    @AppStorage("user_UID") private var userUID: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View
    {
        if sharedEditNotifier.backgroundEdit {
            EditorView(parent: self, elementsArray: $bgElementsArray)
        } else {
            EditorView(parent: self, elementsArray: $elementsArray)
        }
        
    }
    
    struct EditorView: View { // View redeclared to allow for background editing
        
        let parent: Editor
        @Binding var elementsArray: [String : editableElement]
        
        
        var body: some View {
            
            ZStack
            {
//                Color.white
//                    .ignoresSafeArea()
                
                if !elementsArray.isEmpty {
                    feedPredictor(elementsArray: elementsArray)
                }
                
                VStack
                {
                    
                    // Back Button
                    
                    HStack {
                        Button(action: {
                            parent.isEditorActive = false
                        }, label: {
                            ZStack {
                                Circle()
                                    .backgroundStyle(Color.gray)
                                    .opacity(0.8)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: "chevron.backward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.white)
                            }
                        })
                        .tint(.black)
                        .opacity(parent.sharedEditNotifier.buttonDim)
                        .disabled(parent.sharedEditNotifier.disabled)
                        .padding()
                        
                        Spacer()
                        
                        SideButtons(elementsArray: $elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                        
                    }
                    
                    // Side Buttons
                    
                    HStack(alignment: .top){
                        if parent.sharedEditNotifier.rewindButtonPresent {
                            RewindButton(elementsArray: $elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                        }
                        
                        Spacer()                        
                        
                    }
                    .padding()
                    
                    Spacer()
                    
                    bottomButtons(isEditorActive: parent.$isEditorActive, elementsArray: $elementsArray, bgElementsArray: parent.$bgElementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                        .zIndex(Double(parent.sharedEditNotifier.objectsCount + 1))
                    
                    
                }
                .zIndex(Double(parent.sharedEditNotifier.objectsCount + 2))
                
                
                if parent.sharedEditNotifier.backgroundEdit != true {
                    Background(sharedEditNotifier: parent.sharedEditNotifier, elementsArray: parent.$bgElementsArray)
                        .zIndex(-1)
                }
                
                ZStack {
                    ForEach(elementsArray.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                        if let itemToDisplay = elementsArray[key] {
                            EditableElement(element: itemToDisplay, elementsArray: $elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
                            
                        }
                        
                    }
                }
                
                if parent.sharedEditNotifier.currentlyEdited {
                    Trash(sharedEditNotifier: parent.sharedEditNotifier)
                        
                }
                
            }
            
        }
    }
    
}

func feedPredictor(elementsArray: [String : editableElement]) -> some View {
    
    var peak = CGFloat.zero
    
    for (_, element) in elementsArray {
        
        peak = max(peak, ((element.size.height * element.scalar) / 2) + abs(element.position.height))
    }
    
    return ZStack {
        
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(Color.gray)
            .offset(y: -peak)
        
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(Color.gray)
            .offset(y: peak)
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var videoURL: URL?
    @Binding var showImagePicker: Bool
    @Binding var showCamera: Bool
    @Binding var newImageChosen: Bool
    @Binding var elementsArray: [String : editableElement]
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
                
                if originalImage.size.width < screenWidth && originalImage.size.height < postHeight, let image = elementAdd(image: originalImage, sharedEditNotifier: parent.sharedEditNotifier) {
                    parent.elementsArray[image.id] = image
                }
                else
                {
                    if let downsampledImage = originalImage.downsample(to: targetSize), let image = elementAdd(image: downsampledImage, sharedEditNotifier: parent.sharedEditNotifier) {
                        parent.elementsArray[image.id] = image
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
                    
                    // Use screenWidth and maxHeight to calculate aspect ratio and targetSize
                    let screenWidth = UIScreen.main.bounds.width
                    let maxHeight: CGFloat = UIScreen.main.bounds.height
                    let aspectRatio = correctedSize.width / correctedSize.height
                    let targetHeight = min(maxHeight, screenWidth / aspectRatio)
                    let targetSize = CGSize(width: screenWidth, height: targetHeight)
                    
                    if let video = elementAdd(video: (videoUrl, targetSize), sharedEditNotifier: parent.sharedEditNotifier) {
                        parent.elementsArray[video.id] = video
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




enum ClippableShape: Int, Codable {
    
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

// image select settings
// Rotation
// Add link
// Crop



