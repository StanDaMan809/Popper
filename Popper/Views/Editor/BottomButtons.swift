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
                    .vAlign(.bottom)
                    .padding()
            }
            
        case .photoAppear:
            
            Text("Select what you'd like to make appear.")
                .vAlign(.bottom)
            
        case .photoDisappear:
            
            Text("Disappearing Photo (Tap)")
                .vAlign(.bottom)
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
        }
        
    }
    
    struct controlButtons: View {
        
        let parent: bottomButtons
        
        var body: some View {
            HStack
            {
                // photo choosy button
                Button(action: {
                    parent.showImagePicker = true
                },
                       label: {
                        Image(systemName: "photo")
                    
                        .sheet(isPresented: parent.$showImagePicker) {
                            ImagePickerView(image: parent.$image, videoURL: parent.$videoURL, showImagePicker: parent.$showImagePicker, showCamera: parent.$showCamera, newImageChosen: parent.$newImageChosen, elementsArray: parent.elementsArray, sharedEditNotifier: parent.sharedEditNotifier, sourceType: .photoLibrary)
                                .ignoresSafeArea()
                            }
                        
                        
                    
                })
                .scaleEffect(2.5)
                .tint(.black)
                .offset(x: -80)
                .padding()
                
                Button(action: {
                    parent.showCamera = true
                },
                       label: {
                        Image(systemName: "camera.aperture")
                        .sheet(isPresented: parent.$showCamera) {
                            ImagePickerView(image: parent.$image, videoURL: parent.$videoURL, showImagePicker: parent.$showImagePicker, showCamera: parent.$showCamera, newImageChosen: parent.$newImageChosen, elementsArray: parent.elementsArray, sharedEditNotifier: parent.sharedEditNotifier, sourceType: .camera)
                                .ignoresSafeArea()
                            }
                })
                .scaleEffect(4)
                .tint(.black)
                .padding()
                
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
                        Image(systemName: "arrowshape.right")
                })
                .scaleEffect(3)
                .tint(.black)
                .offset(x: 80)
                .padding()
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
            .padding(10)
        }
    }
}
