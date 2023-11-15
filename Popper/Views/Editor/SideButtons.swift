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
    @State var videoURL: URL?
    @State private var newImageChosen = false
    var miniButtonScaleEffect = 0.80
    
    var body: some View
    { VStack
        { switch sharedEditNotifier.pressedButton
            { // Regular Menu
                
            case .noButton:
    //                Button(action: {
    //                    pressedButton = .imageButton
    //                },
    //                       label: {
    //                        Image(systemName: "photo.circle")
    //                })


                    Button(action: {
    //                    sharedEditNotifier.pressedButton = .bgButton
                        sharedEditNotifier.backgroundEdit.toggle()
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
                
                

                // Photo Button Menu
            case .imageEdit:
                
                    Button(action: {
                        sharedEditNotifier.pressedButton = .noButton
                        sharedEditNotifier.restoreDefaults()
                    },
                           label: {
                            Image(systemName: "photo.circle.fill")
                    })
            
                    if !sharedEditNotifier.backgroundEdit {
                        Button(action: {
        //                    change the link value for  sharedEditNotifier.selectedImage
                        },
                               label: {
                                Image(systemName: "link")
                        })
                        .scaleEffect(miniButtonScaleEffect)
                    }
            
                    reusableElementButtons(parent: self)
                

                // Background Button Menu
                case .bgButton:
                
                    Button(action: {
                        sharedEditNotifier.pressedButton = .noButton
                    },
                           label: {
                            Image(systemName: "rectangle.on.rectangle.circle.fill")
                    })
                

                // Extraneous Button Menu
                case .extrasButton:
                
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
                

                case .txtButton:
                
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
                
                
                case .textEdit:
                
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
            
                    reusableElementButtons(parent: self)
                
                
            case .disappeared: // No side buttons...
                VStack { // Doesn't allow nothing to exist
                
                }
                    
                
                
            case .shapeEdit:
                
                    Button(action: {
                        sharedEditNotifier.restoreDefaults()
                    },
                           label: {
                            Image(systemName: "doc.circle.fill")
                    })
                    .scaleEffect(miniButtonScaleEffect)
                    
                    Button(action: {
                        sharedEditNotifier.editorDisplayed = .colorPickerShape
                    },
                           label: {
                            Image(systemName: "paintpalette")
                    })
                    .scaleEffect(miniButtonScaleEffect)
            
                    reusableElementButtons(parent: self)
                
                
                case .elementAppear:
                
                    Button(action: {
                        sharedEditNotifier.restoreDefaults()
                    },
                           label: {
                            Image(systemName: "paperclip.circle.fill")
                    })
                    
                    Button(action: {
                        showImagePicker = true
                    },
                           label: {
                            Image(systemName: "photo")
                            .sheet(isPresented: $showImagePicker) {
                                ImagePickerView(image: $image, videoURL: $videoURL, showImagePicker: $showImagePicker, showCamera: $showCamera, newImageChosen: $newImageChosen, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier, sourceType: .photoLibrary)
                                }
                    })
                    .scaleEffect(miniButtonScaleEffect)
                    
                    Button(action: {
                        textAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
                    },
                           label: {
                            Image(systemName: "text.cursor")
                    })
                    .scaleEffect(miniButtonScaleEffect)
                    
                    Button(action: {
                        shapeAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
                    },
                           label: {
                            Image(systemName: "squareshape")
                    })
                    .scaleEffect(miniButtonScaleEffect)
            
                    Button(action: {
                        sharedEditNotifier.editorDisplayed = .voiceRecorder
                    },
                           label: {
                            Image(systemName: "speaker")
                    })
                    .scaleEffect(miniButtonScaleEffect)
                

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
    
    struct reusableElementButtons: View { // Holds the elementAppear, elementDisappear, transparencyDisappear, and lock that every element uses
        
        let parent: SideButtons
        
        var body: some View {
            VStack {
                if !parent.sharedEditNotifier.backgroundEdit {
                    Button(action: {
    //                    self.showImagePicker = true
                        parent.sharedEditNotifier.editorDisplayed = .photoAppear
                        parent.sharedEditNotifier.pressedButton = .elementAppear
                    },
                           label: {
                            Image(systemName: "photo.on.rectangle.angled")
                        
                    })
                    .scaleEffect(parent.miniButtonScaleEffect)
                }
                
                if !parent.sharedEditNotifier.backgroundEdit {
                    Button(action: {
                        parent.sharedEditNotifier.editorDisplayed = .elementDisappear
                    },
                           label: {
                            Image(systemName: "photo.stack")
                    })
                    .scaleEffect(parent.miniButtonScaleEffect)
                }
                
                Button(action: {
                    if parent.sharedEditNotifier.selectedElement != nil {
                        parent.sharedEditNotifier.editorDisplayed = .transparencySlider
                    }
                },
                       label: {
                        Image(systemName: "square.dotted")}
                
                )
                .scaleEffect(parent.miniButtonScaleEffect)
                
                
                Button(action: {
                    parent.sharedEditNotifier.selectedElement?.element.lock.toggle()
                },
                       label: {
                    Image(systemName: parent.sharedEditNotifier.selectedElement?.element.lock ?? false ? "lock.fill" : "lock")
                })
                .scaleEffect(parent.miniButtonScaleEffect)
            }
        }
    }
}



//struct SideButtonss_Previews: PreviewProvider {
//        static var previews: some View {
//            Editor()
//        }
//    }
