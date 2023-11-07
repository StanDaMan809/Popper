//
//  SideButtons.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

struct SideButtons: View {

    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    @State private var showCamera = false
    @State private var showImagePicker = false
    @State var image: UIImage?
    @State private var newImageChosen = false
    var miniButtonScaleEffect = 0.80
    
    var body: some View
    { VStack()
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
//                    sharedEditNotifier.pressedButton = .bgButton
                    sharedEditNotifier.backgroundEdit.toggle()
                    
                    // systemName: post.likedIDs.contains(userUID) ? "heart.fill" : "heart"
                },
                       label: {
                    Image(systemName: sharedEditNotifier.backgroundEdit ? "rectangle.on.rectangle.circle.fill" : "rectangle.on.rectangle.circle")
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
                    sharedEditNotifier.restoreDefaults()
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
                            ImagePickerView(image: $image, showImagePicker: $showImagePicker, showCamera: $showCamera, newImageChosen: $newImageChosen, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier, sourceType: .photoLibrary)
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
                
                Button(action: {
                    shapeAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
                },
                       label: {
                        Image(systemName: "squareshape")
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
                    textAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
                },
                       label: {
                        Image(systemName: "text.cursor")
                })
                .scaleEffect(miniButtonScaleEffect)
            }
            
            if sharedEditNotifier.pressedButton == .textEdit
            {
                Button(action: {
                    sharedEditNotifier.restoreDefaults()
                },
                       label: {
                        Image(systemName: "t.circle.fill")
                })

                Button(action: {
                    sharedEditNotifier.editorDisplayed = .colorPickerTextBG
                },
                       label: {
                        Image(systemName: "textbox")
                })
                .scaleEffect(miniButtonScaleEffect)
                
                Button(action: {
                    sharedEditNotifier.editorDisplayed = .colorPickerText
                },
                       label: {
                        Image(systemName: "paintpalette")
                })
                .scaleEffect(miniButtonScaleEffect)
                
                Button(action: {
                    sharedEditNotifier.editorDisplayed = .fontPicker
                },
                       label: {
                        Image(systemName: "textformat.size.smaller")
                })
                .scaleEffect(miniButtonScaleEffect)
            }
            
            if sharedEditNotifier.pressedButton == .disappeared
            {
                
            }
            
            if sharedEditNotifier.pressedButton == .shapeEdit
            {
                Button(action: {
                    sharedEditNotifier.restoreDefaults()
                },
                       label: {
                        Image(systemName: "doc.circle.fill")
                })
                
                Button(action: {
                    sharedEditNotifier.editorDisplayed = .colorPickerShape
                },
                       label: {
                        Image(systemName: "paintpalette")
                })
            }

        }
        .tint(.black)
        .scaleEffect(3, anchor: .top)
        .padding(.horizontal, 20)
        .vAlign(.top)
        .hAlign(.trailing)
//        .scaleEffect(3)
//        .padding(20)
        
        .opacity(sharedEditNotifier.buttonDim)
        .disabled(sharedEditNotifier.disabled)
    }
}



//struct SideButtonss_Previews: PreviewProvider {
//        static var previews: some View {
//            Editor()
//        }
//    }
