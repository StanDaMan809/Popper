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
    @State private var showStickerPicker = false
    @State var image: UIImage?
    @State var videoURL: URL?
    @State private var newImageChosen = false
    let grayOpacityRegular = 0.4
    let grayOpacitySelected = 0.8
    
    var body: some View
    {
        HStack
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
                textAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
            },
                   label: {
                sideButton(systemName: "character", grayOpacity: grayOpacityRegular, buttonSizeDifference: 5)
            })
            
            
            Button(action: {
                sharedEditNotifier.pressedButton = .extrasButton
            },
                   label: {
                sideButton(systemName: "ellipsis", grayOpacity: grayOpacityRegular)
                    
            })
            
            if !sharedEditNotifier.profileEdit {
                Button(action: {
                    //                    sharedEditNotifier.pressedButton = .bgButton
                    sharedEditNotifier.backgroundEdit.toggle()
                },
                       label: {
                    sideButton(systemName: "rectangle.on.rectangle.fill", grayOpacity: sharedEditNotifier.backgroundEdit ? grayOpacitySelected : grayOpacityRegular)
                })
            }
            
            
            
            
            
            // Photo Button Menu
        case .imageEdit:
            
            if !sharedEditNotifier.backgroundEdit {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            sharedEditNotifier.pressedButton = .noButton
                            sharedEditNotifier.restoreDefaults()
                        },
                               label: {
                            sideButton(systemName: "photo.fill", grayOpacity: grayOpacitySelected)
                        })
                        
                        if !sharedEditNotifier.backgroundEdit {
                            Button(action: {
                                //                    change the link value for  sharedEditNotifier.selectedImage
                            },
                                   label: {
                                sideButton(systemName: "link", grayOpacity: grayOpacityRegular)
                            })
                        }
                        
                        reusableElementButtons(parent: self)
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                        Button(action: {
                            sharedEditNotifier.pressedButton = .noButton
                            sharedEditNotifier.restoreDefaults()
                        },
                               label: {
                            sideButton(systemName: "photo.fill", grayOpacity: grayOpacitySelected)
                        })
                        
                        if !sharedEditNotifier.backgroundEdit {
                            Button(action: {
                                //                    change the link value for  sharedEditNotifier.selectedImage
                            },
                                   label: {
                                sideButton(systemName: "link", grayOpacity: grayOpacityRegular)
                            })
                        }
                        
                        reusableElementButtons(parent: self)
            }
                        
            
            
            // Background Button Menu
        case .bgButton:
            
            Button(action: {
                sharedEditNotifier.pressedButton = .noButton
            },
                   label: {
                sideButton(systemName: "rectangle.on.rectangle", grayOpacity: grayOpacitySelected)
            })
            
            
            // Extraneous Button Menu
        case .extrasButton:
            
            Button(action: {
                sharedEditNotifier.pressedButton = .noButton
            },
                   label: {
                sideButton(systemName: "ellipsis", grayOpacity: grayOpacitySelected)
            })
            
            Button(action: {
                shapeAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
            },
                   label: {
                sideButton(systemName: "square", grayOpacity: grayOpacityRegular)
            })
            
            Button(action: {
                showStickerPicker = true
            },
                   label: {
                sideButton(systemName: "timer", grayOpacity: grayOpacityRegular)
                    .sheet(isPresented: $showStickerPicker) {
                        GIFController(show: $showStickerPicker, sharedEditNotifier: sharedEditNotifier, elementsArray: elementsArray)
                    }
            })
            
            if !sharedEditNotifier.backgroundEdit {
                Button(action: {
                    pollAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
                },
                       label: {
                    sideButton(systemName: "checkmark.square.fill", grayOpacity: grayOpacityRegular)
                })
            }
            
            
            
        case .textEdit:
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    Button(action: {
                        sharedEditNotifier.restoreDefaults()
                    },
                           label: {
                        sideButton(systemName: "character", grayOpacity: grayOpacitySelected, buttonSizeDifference: 5)
                    })
                    
                    Button(action: {
                        sharedEditNotifier.editorDisplayed = .colorPickerTextBG
                    },
                           label: {
                        sideButton(systemName: "textbox", grayOpacity: grayOpacityRegular)
                    })
                    
                    Button(action: {
                        sharedEditNotifier.editorDisplayed = .colorPickerText
                    },
                           label: {
                        sideButton(systemName: "paintpalette.fill", grayOpacity: grayOpacityRegular)
                    })
                    
                    Button(action: {
                        sharedEditNotifier.editorDisplayed = .fontPicker
                    },
                           label: {
                        sideButton(systemName: "textformat.size", grayOpacity: grayOpacityRegular)
                    })
                    
                    reusableElementButtons(parent: self)
                }
                .padding(.horizontal, 20)
            }
            
            
        case .disappeared: // No side buttons...
            Group {
                
            }
            
        case .shapeEdit:
            
            if !sharedEditNotifier.backgroundEdit {
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            sharedEditNotifier.restoreDefaults()
                        },
                               label: {
                            sideButton(systemName: "square.fill", grayOpacity: grayOpacitySelected)
                        })
                        
                        Button(action: {
                            sharedEditNotifier.editorDisplayed = .colorPickerShape
                        },
                               label: {
                            sideButton(systemName: "paintpalette.fill", grayOpacity: grayOpacityRegular)
                        })
                        
                        reusableElementButtons(parent: self)
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                Button(action: {
                    sharedEditNotifier.restoreDefaults()
                },
                       label: {
                    sideButton(systemName: "square.fill", grayOpacity: grayOpacitySelected)
                })
                
                Button(action: {
                    sharedEditNotifier.editorDisplayed = .colorPickerShape
                },
                       label: {
                    sideButton(systemName: "paintpalette.fill", grayOpacity: grayOpacityRegular)
                })
                
                reusableElementButtons(parent: self)
            }
            
        case .stickerEdit:
            
            if !sharedEditNotifier.backgroundEdit {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            sharedEditNotifier.pressedButton = .noButton
                            sharedEditNotifier.restoreDefaults()
                        },
                               label: {
                            sideButton(systemName: "timer.circle", grayOpacity: grayOpacitySelected)
                        })
                        
                        reusableElementButtons(parent: self)
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                Button(action: {
                    sharedEditNotifier.pressedButton = .noButton
                    sharedEditNotifier.restoreDefaults()
                },
                       label: {
                    sideButton(systemName: "timer.circle", grayOpacity: grayOpacitySelected)
                })
                
                reusableElementButtons(parent: self)
            }
            
        case .pollEdit:
            
                Button(action: {
                    sharedEditNotifier.pressedButton = .noButton
                    sharedEditNotifier.restoreDefaults()
                },
                       label: {
                    sideButton(systemName: "checkmark.square.fill", grayOpacity: grayOpacitySelected)
                })
                
                reusableElementButtons(parent: self)
            
        case .elementAppear:
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button(action: {
                        sharedEditNotifier.restoreDefaults()
                    },
                           label: {
                        sideButton(systemName: "paperclip", grayOpacity: grayOpacitySelected)
                    })
                    
                    Button(action: {
                        showImagePicker = true
                    },
                           label: {
                        sideButton(systemName: "photo", grayOpacity: grayOpacityRegular)
                            .sheet(isPresented: $showImagePicker) {
                                ImagePickerView(image: $image, videoURL: $videoURL, showImagePicker: $showImagePicker, showCamera: $showCamera, newImageChosen: $newImageChosen, elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier, sourceType: .photoLibrary)
                            }
                    })
                    
                    Button(action: {
                        textAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
                    },
                           label: {
                        sideButton(systemName: "character", grayOpacity: grayOpacityRegular)
                    })
                    
                    Button(action: {
                        shapeAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
                    },
                           label: {
                        sideButton(systemName: "square", grayOpacity: grayOpacityRegular)
                    })
                    
                    Button(action: {
                        showStickerPicker = true
                    },
                           label: {
                        sideButton(systemName: "timer", grayOpacity: grayOpacityRegular)
                            .sheet(isPresented: $showStickerPicker) {
                                GIFController(show: $showStickerPicker, sharedEditNotifier: sharedEditNotifier, elementsArray: elementsArray)
                            }
                    })
                    
                    Button(action: {
                        pollAdd(elementsArray: elementsArray, sharedEditNotifier: sharedEditNotifier)
                    },
                           label: {
                        sideButton(systemName: "checkmark.square.fill", grayOpacity: grayOpacityRegular)
                    })
                    
                    Button(action: {
                        sharedEditNotifier.editorDisplayed = .voiceRecorder
                    },
                           label: {
                        sideButton(systemName: "speaker.wave.2.fill", grayOpacity: grayOpacityRegular)
                    })
                }
                .padding(.horizontal, 20)
            }
        }
        }
        .tint(.black)
//        .padding(.horizontal, (sharedEditNotifier.pressedButton == .noButton || sharedEditNotifier.pressedButton == .bgButton || sharedEditNotifier.pressedButton == .extrasButton || sharedEditNotifier.pressedButton == .stickerEdit) ? 20 : 0)
        .padding(.horizontal, (needsPadding()) ? 20 : 0)
        
        .opacity(sharedEditNotifier.buttonDim)
        .disabled(sharedEditNotifier.disabled)
    }
    
    struct reusableElementButtons: View { // Holds the elementAppear, elementDisappear, transparencyDisappear, and lock that every element uses
        
        let parent: SideButtons
        
        var body: some View {
            if !parent.sharedEditNotifier.backgroundEdit, parent.sharedEditNotifier.pressedButton != .pollEdit {
                    Button(action: {
                        //                    self.showImagePicker = true
                        parent.sharedEditNotifier.editorDisplayed = .photoAppear
                        parent.sharedEditNotifier.pressedButton = .elementAppear
                    },
                           label: {
                        sideButton(systemName: "plus", grayOpacity: parent.grayOpacityRegular, buttonSizeDifference: 5)
                        
                    })
                
                    Button(action: {
                        parent.sharedEditNotifier.editorDisplayed = .elementDisappear
                    },
                           label: {
                        sideButton(systemName: "minus", grayOpacity: parent.grayOpacityRegular, buttonSizeDifference: 5)
                    })
                }
                
                Button(action: {
                    if parent.sharedEditNotifier.selectedElement != nil {
                        parent.sharedEditNotifier.editorDisplayed = .transparencySlider
                    }
                },
                       label: {
                    sideButton(systemName: "square.dotted", grayOpacity: parent.grayOpacityRegular)
                }
                       
                )
                
                
                Button(action: {
                    parent.sharedEditNotifier.selectedElement?.element.lock.toggle()
                },
                       label: {
                    sideButton(systemName: parent.sharedEditNotifier.selectedElement?.element.lock ?? false ? "lock.fill" : "lock", grayOpacity: parent.grayOpacityRegular)
                })
            
        }
    }
    
    struct sideButton: View {
        let buttonSize: CGFloat = 30
        let buttonBGSize: CGFloat = 50
        let systemName: String
        let grayOpacity: CGFloat
        let buttonSizeDifference: CGFloat
        
        init(systemName: String, grayOpacity: CGFloat, buttonSizeDifference: CGFloat = 0) {
            self.systemName = systemName
            self.grayOpacity = grayOpacity
            self.buttonSizeDifference = buttonSizeDifference
        }
        
        var body: some View {
            ZStack {
                Circle()
                    .backgroundStyle(Color.gray)
                    .opacity(grayOpacity)
                    .frame(width: buttonBGSize, height: buttonBGSize)
                
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonSize - buttonSizeDifference, height: buttonSize - buttonSizeDifference)
                    .foregroundStyle(Color.white)
                    
            }
        }
    }
    
    func needsPadding() -> Bool { // Checks and disables padding if a ScrollView is necessary for the current display
        
        
        if (sharedEditNotifier.backgroundEdit && sharedEditNotifier.pressedButton != .textEdit) || (sharedEditNotifier.backgroundEdit && sharedEditNotifier.pressedButton != .shapeEdit) || sharedEditNotifier.pressedButton == .noButton || sharedEditNotifier.pressedButton == .bgButton || sharedEditNotifier.pressedButton == .extrasButton || sharedEditNotifier.pressedButton == .pollEdit { // basically if not scrollview
            return true
        } else {
            return false
        }
    }
}
