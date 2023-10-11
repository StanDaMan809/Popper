//
//  SideButtons.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

struct PhotoEditButton: View {
    
    @ObservedObject var imgArray: imagesArray
    @ObservedObject var txtArray: textsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    @ObservedObject var imgAdded: imageAdded
    @State private var showImagePicker = false
    @State var image: UIImage?
    @State private var newImageChosen = false
    var miniButtonScaleEffect = 0.80
    
    var body: some View
    { VStack(alignment: .leading)
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
                    textAdd(textArray: txtArray)
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
            
//            Spacer()

        }
        .tint(.black)
        .scaleEffect(3, anchor: .top)
        .padding(.horizontal, 20)
//        .vAlign(.top)
//        .hAlign(.trailing)
//        .scaleEffect(3)
//        .padding(20)
        
        .opacity(sharedEditNotifier.buttonDim)
        .disabled(sharedEditNotifier.disabled)
    }
}
