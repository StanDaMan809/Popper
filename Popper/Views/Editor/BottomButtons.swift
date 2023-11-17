//
//  BottomButtons.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

struct bottomButtons: View {

    @Binding var isEditorActive: Bool
    @State private var showCamera = false
    @State private var showImagePicker = false
    @State var image: UIImage?
    @State var videoURL: URL?
    @State private var newImageChosen = false
    @State private var createNewPost: Bool = false
    @State private var recentsPosts: [Post] = []
    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View
    {
        
        switch sharedEditNotifier.editorDisplayed {
            
        case .none:
            
            if sharedEditNotifier.currentlyEdited == false {
                controlButtons(parent: self)
                    .opacity(sharedEditNotifier.buttonDim)
            } else {
               Trash(sharedEditNotifier: sharedEditNotifier)
            }
            
        case .linkEditor:
            
            Text("Placeholder")
            
        case .transparencySlider:
            
            if let currentlySelected = sharedEditNotifier.selectedElement
            {
                TransparencySlider(transparency: Binding(get: { currentlySelected.element.transparency }, set: { currentlySelected.element.transparency = $0 }))
                    .padding()
            }
            
        case .photoAppear:
            
            Text("Select what you'd like to make appear.")
                .padding()
            
        case .elementDisappear:
            
            Text("Disappearing Photo (Tap)")
                .padding()
            
        case .colorPickerText:
            
            if let currentlySelectedCandidate = sharedEditNotifier.selectedElement
            {
                if case .text(let currentlySelected) = currentlySelectedCandidate.element {
                    ColorPicker(elementColor: Binding(get: {currentlySelected.color}, set: { currentlySelected.color = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
                }
                
            }
            
        case .colorPickerTextBG:
            if let currentlySelectedCandidate = sharedEditNotifier.selectedElement
            {
                if case .text(let currentlySelected) = currentlySelectedCandidate.element {
                    ColorPicker(elementColor: Binding(get: {currentlySelected.bgColor}, set: { currentlySelected.bgColor = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
                }
            }
            
            
        case .colorPickerShape:
            if let currentlySelectedCandidate = sharedEditNotifier.selectedElement
            {
                if case .shape(let currentlySelected) = currentlySelectedCandidate.element {
                    ColorPicker(elementColor: Binding(get: {currentlySelected.color}, set: { currentlySelected.color = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
                }
            }
            
        case .fontPicker:
            if let currentlySelectedCandidate = sharedEditNotifier.selectedElement
            {
                if case .text(let currentlySelected) = currentlySelectedCandidate.element {
                    FontPicker(textFont: Binding(get: {currentlySelected.font }, set: {  currentlySelected.font = $0 }), sharedEditNotifier: sharedEditNotifier)
                        .vAlign(.bottom)
                }
            }
            
        case .voiceRecorder:
            audioButton(sharedEditNotifier: sharedEditNotifier)
        }
        
    }
    
    struct controlButtons: View {
        
        let parent: bottomButtons
        let bgSize: CGFloat = 50
        let photoSize: CGFloat = 30
        
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
                            ImagePickerView(image: parent.$image, videoURL: parent.$videoURL, showImagePicker: parent.$showImagePicker, showCamera: parent.$showCamera, newImageChosen: parent.$newImageChosen, elementsArray: parent.elementsArray, sharedEditNotifier: parent.sharedEditNotifier, sourceType: .photoLibrary)
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
                            ImagePickerView(image: parent.$image, videoURL: parent.$videoURL, showImagePicker: parent.$showImagePicker, showCamera: parent.$showCamera, newImageChosen: parent.$newImageChosen, elementsArray: parent.elementsArray, sharedEditNotifier: parent.sharedEditNotifier, sourceType: .camera)
                                .ignoresSafeArea()
                            }
                })
                .tint(.black)
                
                Spacer()
                
                Button(action: {
                    parent.sharedEditNotifier.backgroundEdit = false // Just in case they're editing the background, we don't want them to upload the background stuff as their post
                    parent.createNewPost.toggle()
    //                CreateNewPost(onPost: { post in
    //                    recentsPosts.insert(post, at: 0)
    //                }, imgArray: imgArray, txtArray: txtArray)
    //                { post in
    //                    recentsPosts.insert(post, at: 0)
    //                }
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
                        parent.elementsArray.elements.removeAll()
                        parent.isEditorActive = false
                        
                    }, elementsArray: parent.elementsArray)
                }
                
            }
            .vAlign(.bottom)
            .padding(.horizontal, 20)
        }
    }
}
