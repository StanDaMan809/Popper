//
//  Editor.swift
//  Popper
//
//  Created by Stanley Grullon on 4/6/23.
//

import SwiftUI

struct Editor: View {
    
    @StateObject var sharedEditNotifier = SharedEditState()
    @State private var isPressed = false
    @StateObject var imgArray = imagesArray()
    @StateObject var imgAdded = imageAdded()
    
    @State var texts: [editableTxt] =
    [
        editableTxt(id: 3, message: "Lorem Ipsum", totalOffset: CGPoint(x: 200, y: 400), txtColor: Color(red: 0.0, green: 0.0, blue: 0.0), size: [80, 80], scalar: 1.0, rotationDegrees: 0.0)
    ]
    
    var body: some View
    {
        @State var UIPrio = Double(imgArray.images.count + texts.count + 1)
        @State var editTextPrio = UIPrio - 1
        @State var editbarPrio = UIPrio + 2
        @State var actionButtonPrio = UIPrio + 3
        
        ZStack
        {
            Background(sharedEditNotifier: sharedEditNotifier)
            EditorDisplays(sharedEditNotifier: sharedEditNotifier)
            EditorBars()
                .zIndex(editbarPrio)
            EditorTopUIButtons()
                .zIndex(UIPrio)
            PhotoEditButton(imgArray: imgArray, sharedEditNotifier: sharedEditNotifier, imgAdded: imgAdded)
                .zIndex(UIPrio)
            bottomButtons(imgArray: imgArray, imgAdded: imgAdded, sharedEditNotifier: sharedEditNotifier)
                .zIndex(actionButtonPrio)
            ForEach(imgArray.images.indices, id: \.self)
                { index in
                    EditableImage(image: imgArray.images[index],imgArray: imgArray, sharedEditNotifier: sharedEditNotifier)
                    
//                    if imgArray.images[index].createDisplays.images[0].display {
//                        ForEach(imgArray.images[index].createDisplays.images.indices, id: \.self) { index2 in
//                            EditableImage(image: imgArray.images[index].createDisplays.images[index2], sharedEditNotifier: sharedEditNotifier)
//                        }
//                    }
                }
            ForEach(texts.indices, id: \.self)
            { index in
                EditableText(text: texts[index], sharedEditNotifier: sharedEditNotifier, editPrio: editTextPrio)
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
        .scaleEffect(1.2)
        .position(x: 40, y: 0)
        .tint(.white)
        
    }
}

struct Background: View {
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View {
        Color(.white)
            .onTapGesture {
                sharedEditNotifier.selectedImage = nil
                sharedEditNotifier.editorDisplayed = .none
                sharedEditNotifier.pressedButton = .noButton
            }
            .zIndex(-1)
    }
}

var topBarOffsetx = 0.0
var topBarOffsety = -400.0
var bottomBarOffsetx = 0.0
var bottomBarOffsety = 350.0

struct EditorBars: View {
    
    var body: some View
    {
        Group
        {
            Color.gray
                .frame(width: 400, height: 150)
                .offset(x: topBarOffsetx, y: topBarOffsety)
            
            Color.gray
                .frame(width: 400, height: 150)
                .offset(x: bottomBarOffsetx, y: bottomBarOffsety)
        }
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

class imagesArray: ObservableObject {
    @Published var images: [editableImg] =
    [
//        editableImg(id: 0, imgSrc: "Image", currentShape: .rectangle, totalOffset: CGPoint(x: 150, y: 500), size: [50, 80], scalar: 1.0),
//        editableImg(id: 1, imgSrc: "Slay", currentShape: .rectangle, totalOffset: CGPoint(x: 70, y: 500), size: [50, 80], scalar: 1.0)
    ]
}


func imageAdd(imgSource: UIImage, imgArray: imagesArray, imgAdded: imageAdded, sharedEditNotifier: SharedEditState) {
    
    // if sharedEditState blah blah blah
    
    imgAdded.imgAdded = true
    
    if sharedEditNotifier.editorDisplayed == .photoAppear {
        
        if let currentImg = sharedEditNotifier.selectedImage
        {
            currentImg.createDisplays.append(imgArray.images.endIndex)
            imgArray.images.append(editableImg(id: imgArray.images.count, imgSrc: imgSource, currentShape: .rectangle, totalOffset: CGPoint(x: 150, y: 500), size: [50, 80], scalar: 1.0, display: false, transparency: 1))
            imgAdded.addIndex = imgArray.images.endIndex - 1
        }
        
    }

    else
    {
        imgArray.images.append(editableImg(id: imgArray.images.count, imgSrc: imgSource, currentShape: .rectangle, totalOffset: CGPoint(x: 150, y: 500), size: [50, 80], scalar: 1.0, display: true, transparency: 1))

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

struct bottomButtons: View {
    @State private var showImagePicker = false
    @State var image: UIImage?
    @State private var newImageChosen = false
    @ObservedObject var imgArray: imagesArray
    @ObservedObject var imgAdded: imageAdded
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View
    {
        HStack
        {
            // photo choosy button
            Button(action: {
                self.showImagePicker = true
            },
                   label: {
                    Image(systemName: "photo")
                
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(image: self.$image, showImagePicker: self.$showImagePicker, newImageChosen: self.$newImageChosen, imgArray: self.imgArray, imgAdded: self.imgAdded, sharedEditNotifier: self.sharedEditNotifier)
                        }
                    
                    
                
            })
            .scaleEffect(3.5)
            .tint(.black)
            .offset(x: -80)
            .padding()
            
            Button(action: {
                
            },
                   label: {
                    Image(systemName: "camera.aperture")
            })
            .scaleEffect(4)
            .tint(.black)
            .padding()
            
            Button(action: {
                
            },
                   label: {
                    Image(systemName: "arrowshape.right")
            })
            .scaleEffect(3.5)
            .tint(.black)
            .offset(x: 80)
            .padding()
            
        }
        .offset(y: 335)
        .frame(maxWidth: .infinity)
        
    }
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
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = image
                imageAdd(imgSource: image, imgArray: parent.imgArray, imgAdded: parent.imgAdded, sharedEditNotifier: parent.sharedEditNotifier)
            }
            parent.showImagePicker = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showImagePicker = false
        }
        
    }
}

struct PhotoEditButton: View {
    
    @ObservedObject var imgArray: imagesArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    @ObservedObject var imgAdded: imageAdded
    @State private var showImagePicker = false
    @State var image: UIImage?
    @State private var newImageChosen = false
    var miniButtonScaleEffect = 0.80
    
    var body: some View
    { VStack (alignment: .leading)
        { // Regular Menu
            if sharedEditNotifier.pressedButton == .noButton
            {
//                Button(action: {
//                    pressedButton = .imageButton
//                },
//                       label: {
//                        Image(systemName: "photo.circle")
//                })


                Button(action: {
                    sharedEditNotifier.pressedButton = .bgButton
                },
                       label: {
                        Image(systemName: "rectangle.on.rectangle.circle")
                })


                Button(action: {
                    sharedEditNotifier.pressedButton = .extrasButton
                },
                       label: {
                        Image(systemName: "doc.circle")
                })


                Button(action: {
                    sharedEditNotifier.pressedButton = .txtButton
                },
                       label: {
                        Image(systemName: "t.circle")
                })
            }

            // Photo Button Menu
            if sharedEditNotifier.pressedButton == .imageEdit
            {
                Button(action: {
                    sharedEditNotifier.pressedButton = .noButton
                },
                       label: {
                        Image(systemName: "photo.circle.fill")
                })
                
                Button(action: {
//                    change the link value for  sharedEditNotifier.selectedImage
                },
                       label: {
                        Image(systemName: "link")
                })
                .scaleEffect(miniButtonScaleEffect)
                
                Button(action: {
                    if sharedEditNotifier.selectedImage != nil {
                        sharedEditNotifier.editorDisplayed = .transparencySlider
                    }
                },
                       label: {
                        Image(systemName: "square.dotted")}
                
                )
                .scaleEffect(miniButtonScaleEffect)
                
                Button(action: {
                    self.showImagePicker = true
                    sharedEditNotifier.editorDisplayed = .photoAppear
                },
                       label: {
                        Image(systemName: "photo.on.rectangle.angled")
                    
                        .sheet(isPresented: $showImagePicker) {
                            ImagePickerView(image: self.$image, showImagePicker: self.$showImagePicker, newImageChosen: self.$newImageChosen, imgArray: self.imgArray, imgAdded: self.imgAdded, sharedEditNotifier: sharedEditNotifier)
                            }
                    
                })
                .scaleEffect(miniButtonScaleEffect)
                
                Button(action: {
                    sharedEditNotifier.editorDisplayed = .photoDisappear
                },
                       label: {
                        Image(systemName: "photo.stack")
                })
                .scaleEffect(miniButtonScaleEffect)
                
                Button(action: {
                    
                },
                       label: {
                        Image(systemName: "lock")
                })
                .scaleEffect(miniButtonScaleEffect)
            }

            // Background Button Menu
            if sharedEditNotifier.pressedButton == .bgButton
            {
                Button(action: {
                    sharedEditNotifier.pressedButton = .noButton
                },
                       label: {
                        Image(systemName: "rectangle.on.rectangle.circle.fill")
                })
            }

            // Extraneous Button Menu
            if sharedEditNotifier.pressedButton == .extrasButton
            {
                Button(action: {
                    sharedEditNotifier.pressedButton = .noButton
                },
                       label: {
                        Image(systemName: "doc.circle.fill")
                })
            }

            if sharedEditNotifier.pressedButton == .txtButton
            {
                Button(action: {
                    sharedEditNotifier.pressedButton = .noButton
                },
                       label: {
                        Image(systemName: "t.circle.fill")
                })

                Button(action: {
//                    makeText()
                },
                       label: {
                        Image(systemName: "text.cursor")
                })
                .scaleEffect(miniButtonScaleEffect)
            }
            
            if sharedEditNotifier.pressedButton == .textEdit
            {
                Button(action: {
                    
                },
                       label: {
                        Image(systemName: "t.circle.fill")
                })

                Button(action: {
//                    Outline Button
                },
                       label: {
                        Image(systemName: "textbox")
                })
                .scaleEffect(miniButtonScaleEffect)
                
                Button(action: {
//                    Color
                },
                       label: {
                        Image(systemName: "paintpalette")
                })
                .scaleEffect(miniButtonScaleEffect)
                
                Button(action: {
//                    Rotation
                },
                       label: {
                        Image(systemName: "arrow.2.circlepath.circle")
                })
                .scaleEffect(miniButtonScaleEffect)
            }
            
            if sharedEditNotifier.pressedButton == .disappeared
            {
                
            }

            Spacer()
        }
        .tint(.black)
        .scaleEffect(3)
        .position(x: 360, y: 1250)
        .opacity(sharedEditNotifier.buttonDim)
        .disabled(sharedEditNotifier.disabled)
    }
}

// These are the text instances
class editableTxt: ObservableObject {
    @Published var id: Int
    // Include color as a dimension
    // Include font as a dimension
    // Include alignment
    @Published var message: String
    @Published var totalOffset: CGPoint = CGPoint(x:0, y: 0)
    @Published var txtColor: Color
    @Published var size: [CGFloat] = [80, 40]
    @Published var scalar: Double
    @Published var rotationDegrees: Double
    var startPosition: CGPoint
    
    
    init(id: Int, message: String, totalOffset: CGPoint, txtColor: Color, size: [CGFloat], scalar: Double, rotationDegrees: Double)
    {
    self.id = id
    self.message = message
    self.totalOffset = totalOffset
    self.size = size
    self.txtColor = txtColor
    self.scalar = scalar
    self.rotationDegrees = rotationDegrees
    self.startPosition = totalOffset
    }
}

struct EditableText: View {
    
    @ObservedObject var text: editableTxt
    @ObservedObject var sharedEditNotifier: SharedEditState
    @State var currentAmount = 0.0
    @GestureState var currentRotation = Angle.zero
    @State var finalRotation = Angle.zero
    @State var textSelected = false
    let defaultTextSize = CGFloat(24.0)
    let defaultTextFrame = CGFloat(300)
    var editPrio: Double = 1
    
    var body: some View
        {
            if textSelected {
                
                // How to make button disappear
                    // Make a class of that enumerator thing that I made
                    // Make an @State variable that changes with it that is equal to the button UI
                    // Make an environment object that changes the enumerator to .disappeared? kinda changes everything?
                    // launch UIButtonWhatever(enum: disappeared)
                
                Color.black
                    .opacity(0.4)
                    .zIndex(editPrio)
                
                    .onTapGesture {
                        textSelected.toggle()
                        sharedEditNotifier.pressedButton = .noButton
                    }
                
                TextField("", text: $text.message, axis: .vertical)
                    .font(.system(size: defaultTextSize))
                    .foregroundColor(text.txtColor)
                    .offset(x: 0, y: -100)
                    .frame(width: defaultTextFrame)
                    .zIndex(editPrio) // Controls layer
                    .multilineTextAlignment(.center)
                    .onSubmit {
                        textSelected.toggle()
                        sharedEditNotifier.pressedButton = .noButton
                    }
            }
            else
            {
                Text(text.message)
                    // Text characteristics
                    .font(.system(size: defaultTextSize))
                    .frame(width: defaultTextFrame)
                    .scaleEffect(text.scalar + currentAmount)
                    .position(text.totalOffset)
                    .zIndex(Double(text.id)) // Controls layer
                    .multilineTextAlignment(.center)
                    .foregroundColor(text.txtColor)
                    .rotationEffect(currentRotation + finalRotation)
                    
                    // Text gestures
                    .onTapGesture
                    {
                        textSelected.toggle()
                        sharedEditNotifier.pressedButton = .textEdit
                    }
                    .gesture(
                        DragGesture() // Have to add UI disappearing but not yet
                            .onChanged { gesture in
                                let scaledWidth = text.size[0] * CGFloat(text.scalar)
                                let scaledHeight = text.size[1] * CGFloat(text.scalar)
                                let halfScaledWidth = scaledWidth / 2
                                let halfScaledHeight = scaledHeight / 2
                                let newX = min(max(gesture.location.x - halfScaledWidth, 0), 400 - scaledWidth) + halfScaledWidth
                                let newY = min(max(gesture.location.y - halfScaledHeight, 80), 630 - scaledHeight) + halfScaledHeight
                                text.totalOffset = CGPoint(x: newX, y: newY)
                                
                                sharedEditNotifier.currentlyEdited = true
                                sharedEditNotifier.editToggle()
                                        }
                        
                            .onEnded { gesture in
                                text.startPosition = text.totalOffset
                                
                                sharedEditNotifier.currentlyEdited = false
                                sharedEditNotifier.editToggle()
                            })
                
//                    .gesture(
//                        RotationGesture()
//                        .updating($currentRotation) { value, state, _ in state = value }
//                                .onEnded { value in
//                                        finalRotation += value
//                                               })
//
//                    .gesture(
//                        MagnificationGesture()
//                            .onChanged { amount in
//                                currentAmount = amount - 1
//                            }
//                            .onEnded { amount in
//                                text.scalar += currentAmount
//                                currentAmount = 0
//                            })
                
                    .gesture(
                        SimultaneousGesture(
                            RotationGesture()
                                .updating($currentRotation) { value, state, _ in state = value }
                                .onEnded { value in
                                    finalRotation += value
                                },
                            MagnificationGesture()
                                .onChanged { amount in
                                    currentAmount = amount - 1
                                }
                                .onEnded { amount in
                                    text.scalar += currentAmount
                                    currentAmount = 0
                                }
                        )
                    )
                
                
            }
        }
}

// these are the image classes
class editableImg: ObservableObject {
    @Published var id: Int
    let imgSrc: UIImage
    @Published var currentShape: ClippableShape = .rectangle
    @Published var totalOffset: CGPoint = CGPoint(x: 0, y: 0)
    @Published var size: [CGFloat] = [80, 40]
    @Published var scalar: Double
    @Published var transparency: Double
    @Published var display: Bool
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    var startPosition: CGPoint
    
    init(id: Int, imgSrc: UIImage, currentShape: ClippableShape, totalOffset: CGPoint, size: [CGFloat], scalar: Double, display: Bool, transparency: Double) {
        self.id = id
        self.imgSrc = imgSrc
        self.currentShape = currentShape
        self.totalOffset = totalOffset
        self.size = size
        self.scalar = scalar
        self.startPosition = totalOffset // initialize startPosition by equating it to totalOffset
        self.display = display
        self.transparency = transparency
    }
}

struct EditableImage: View {
    
    @ObservedObject var image: editableImg
    @ObservedObject var imgArray: imagesArray
    @State var currentAmount = 0.0
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View
        {
            if image.display
            {
                Image(uiImage: image.imgSrc)
                    // Image characteristics
                    .resizable()
                    .frame(width: image.size[0], height: image.size[1])
                    .clipShape(image.currentShape)
                    .scaleEffect(image.scalar + currentAmount)
                    .position(image.totalOffset)
                    .zIndex(Double(image.id)) // Controls layer
                    .opacity(image.transparency)
                    
                    // Image Gestures
                
                    .onTapGesture (count: 2)
                    {
                        image.currentShape = image.currentShape.next
    
                    }
                
                    .onTapGesture
                    {
                        if sharedEditNotifier.editorDisplayed == .photoDisappear {
                            sharedEditNotifier.selectedImage?.disappearDisplays.append(self.image.id)
                            sharedEditNotifier.editorDisplayed = .none
                        }
                        
                        else
                        {
                                for i in image.createDisplays
                                {
                                    imgArray.images[i].display = true
                                }
                                
                                for i in image.disappearDisplays
                                {
                                    imgArray.images[i].display = false
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
                                let newX = min(max(gesture.location.x - halfScaledWidth, 0), 400 - scaledWidth) + halfScaledWidth
                                let newY = min(max(gesture.location.y - halfScaledHeight, 80), 630 - scaledHeight) + halfScaledHeight
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
                        MagnificationGesture()
                            .onChanged { amount in
                                currentAmount = amount - 2
                                sharedEditNotifier.currentlyEdited = true
                                sharedEditNotifier.editToggle()
                            }
                            .onEnded { amount in
                                image.scalar += currentAmount
                                currentAmount = 0
                                sharedEditNotifier.currentlyEdited = false
                                sharedEditNotifier.editToggle()
                                
                            })
                
                    .gesture(LongPressGesture()
                        .onEnded{_ in
                    sharedEditNotifier.pressedButton = .imageEdit
                    sharedEditNotifier.selectImage(editableImg: image)
                            })
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


    

