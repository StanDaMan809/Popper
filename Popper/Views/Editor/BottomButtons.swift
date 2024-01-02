//
//  BottomButtons.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct bottomButtons: View {

    @Binding var isEditorActive: Bool
    @State private var showCamera = false
    @State private var showImagePicker = false
    @State var image: UIImage?
    @State var videoURL: URL?
    @State private var newImageChosen = false
    @State private var createNewPost: Bool = false
    @State private var recentsPosts: [Post] = []
    @Binding var elementsArray: [String : editableElement]
    @Binding var bgElementsArray: [String : editableElement]
    @ObservedObject var sharedEditNotifier: SharedEditState
    @AppStorage("user_UID") private var userUID: String = ""
    
    
    var body: some View
    {
        
        switch sharedEditNotifier.editorDisplayed {
            
        case .none:
            
            if sharedEditNotifier.currentlyEdited == false {
                controlButtons(parent: self)
                    .opacity(sharedEditNotifier.buttonDim)
            } else {
               
                
            }
            
        case .linkEditor:
            
            Text("Placeholder")
            
        case .transparencySlider:
            
            if let currentlySelected = sharedEditNotifier.selectedElement
            {
                TransparencySlider(transparency: Binding(get: { currentlySelected.transparency }, set: { currentlySelected.transparency = $0 }))
                    .padding()
            }
            
        case .photoAppear:
            
            Text("Select what you'd like to make appear.")
                .padding()
            
        case .elementDisappear:
            
            Text("Disappearing Photo (Tap)")
                .padding()
            
        case .colorPickerText:
            
            if let currentlySelected = sharedEditNotifier.selectedElement as? editorText
            {
                
                    ColorPicker(elementColor: Binding(get: {currentlySelected.color}, set: { currentlySelected.color = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
                
                
            }
            
        case .colorPickerTextBG:
            if let currentlySelected = sharedEditNotifier.selectedElement as? editorText
            {
                    ColorPicker(elementColor: Binding(get: {currentlySelected.bgColor}, set: { currentlySelected.bgColor = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
            }
            
            
        case .colorPickerShape:
            if let currentlySelected = sharedEditNotifier.selectedElement as? editorShape
            {
                    ColorPicker(elementColor: Binding(get: {currentlySelected.color}, set: { currentlySelected.color = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
            }
            
        case .fontPicker:
            if let currentlySelected = sharedEditNotifier.selectedElement as? editorText
            {
                
                    FontPicker(textFont: Binding(get: {currentlySelected.font }, set: {  currentlySelected.font = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
                
            }
            
        case .voiceRecorder:
            audioButton(sharedEditNotifier: sharedEditNotifier)
            
        case .colorPickerPollTop:
            if let currentlySelected = sharedEditNotifier.selectedElement as? editorPoll {
                
                    ColorPicker(elementColor: Binding(get: {currentlySelected.topColor}, set: { currentlySelected.topColor = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
                
            }
        case .colorPickerPollBG:
            if let currentlySelected = sharedEditNotifier.selectedElement as? editorPoll {
                
                    ColorPicker(elementColor: Binding(get: {currentlySelected.bottomColor}, set: { currentlySelected.bottomColor = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
                
            }
        case .colorPickerPollButton:
            if let currentlySelected = sharedEditNotifier.selectedElement as? editorPoll {
                    ColorPicker(elementColor: Binding(get: {currentlySelected.buttonColor}, set: { currentlySelected.buttonColor = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
                
            }
        }
        
    }
    
    struct controlButtons: View {
        
        let parent: bottomButtons
        let bgSize: CGFloat = 50
        let photoSize: CGFloat = 30
        @Environment(\.colorScheme) var colorScheme
        
        var body: some View {
            HStack
            {
                // photo choosy button
                Button(action: {
                    parent.showImagePicker = true
                },
                       label: {
                    ZStack {
                        Circle()
                            .backgroundStyle(Color.black)
                            .opacity(0.8)
                            .frame(width: bgSize, height: bgSize)
                        
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: photoSize, height: photoSize)
                            .foregroundStyle(Color.white)
                    }
                    
                        .sheet(isPresented: parent.$showImagePicker) {
                            ImagePickerView(image: parent.$image, videoURL: parent.$videoURL, showImagePicker: parent.$showImagePicker, showCamera: parent.$showCamera, newImageChosen: parent.$newImageChosen, elementsArray: parent.$elementsArray, sharedEditNotifier: parent.sharedEditNotifier, sourceType: .photoLibrary)
                                .ignoresSafeArea()
                            }
                        
                        
                    
                })
                .tint(.black)
//                .offset(x: -80)
                
                Spacer()
                
                Button(action: {
                    parent.showCamera = true
                },
                       label: {
                        Image(systemName: "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .opacity(0.8)
                        
                        .sheet(isPresented: parent.$showCamera) {
                            ImagePickerView(image: parent.$image, videoURL: parent.$videoURL, showImagePicker: parent.$showImagePicker, showCamera: parent.$showCamera, newImageChosen: parent.$newImageChosen, elementsArray: parent.$elementsArray, sharedEditNotifier: parent.sharedEditNotifier, sourceType: .camera)
                                .ignoresSafeArea()
                            }
                })
                .tint(colorScheme == .dark ? Color.white : Color.black)
                
                Spacer()
                
                Button(action: {
                    
                    if !parent.sharedEditNotifier.profileEdit {
                        parent.sharedEditNotifier.backgroundEdit = false // Just in case they're editing the background, we don't want them to upload the background stuff as their post
                        parent.createNewPost.toggle()
                    } else {
                        
                        // Save to profile background
                        
                        parent.updateBackground(elementsArray: parent.bgElementsArray)
                        parent.isEditorActive = false
                        
                        
                    }

                },
                       label: {
                    ZStack {
                        Circle()
                            .backgroundStyle(Color.black)
                            .opacity(0.8)
                            .frame(width: bgSize, height: bgSize)
                        
                        Image(systemName: "arrow.forward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: photoSize, height: photoSize)
                            .foregroundStyle(Color.white)
                    }
                })
                .tint(.black)
//                .offset(x: 80)
                .fullScreenCover(isPresented: parent.$createNewPost) {
                    CreateNewPost(onPost: { post in
                        // Adding created post at the top of the recent post
                        parent.recentsPosts.insert(post, at: 0)
                        
                        // Placeholder: Include saving the post as an image, etc.
                        
                        // Wiping Editor and Getting Rid of It
                        parent.elementsArray.removeAll()
                        parent.isEditorActive = false
                        
                    }, elementsArray: parent.$elementsArray)
                }
                
            }
            .vAlign(.bottom)
            .padding(.horizontal, 20)
            .padding(.vertical)
        }
    }
    
    func updateBackground(elementsArray: [String : editableElement]) {
        Task {
            do {
                
                guard let conversionData = thumbnail(elementsArray: elementsArray) else {return}
                
                guard let data = conversionData.pngData() else {return}
                
                let thumbnailReferenceID = "\(userUID)\(Date())"
                
                let storageRef = Storage.storage().reference().child("Thumbnails").child(thumbnailReferenceID)
                
                let _ = try await storageRef.putDataAsync(data)
                
                let downloadURL = try await storageRef.downloadURL()
                
                let profileReference = Firestore.firestore().collection("Users").document(userUID)
                
                let _ = try await profileReference.setData(["profile" : ["background" : downloadURL.absoluteString]], merge: true)
                
            } catch {
                print(error)
            }
        }
    }
}
