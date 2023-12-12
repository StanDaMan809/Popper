//
//  ProfileBar.swift
//  Popper
//
//  Created by Stanley Grullon on 12/7/23.
//

import SwiftUI
import _PhotosUI_SwiftUI
import UIKit

struct ProfileBar: View {
    
    let userUID: String
    @State var add: Bool = false
    @State var displayPhotoPicker: Bool = false
    @State var editorDisplayed: EditorDisplayEnum = .none
    @State var backgroundEdit: Bool = false
    @Binding var profileElementsArray: [profileElement]
    @Binding var classElementsArray: [profileElementClass]
    @Binding var selectedElement: profileElementClass?
    
    var body: some View {
        VStack {
            
            switch editorDisplayed {
            case .none:
                EmptyView()
            case .colorPickerShape:
                if case .shape(let shape) = selectedElement?.element {
                    ColorPicker(elementColor: Binding(get: {shape.color}, set: { shape.color = $0 }), sharedEditNotifier: SharedEditState())
                    
                }
            case .colorPickerBillboardBG:
                if case .billboard(let billboard) = selectedElement?.element {
                    ColorPicker(elementColor: Binding(get: {billboard.bgColor}, set: { billboard.bgColor = $0 }), sharedEditNotifier: SharedEditState())
                }
            case .colorPickerBillboardTxt:
                if case .billboard(let billboard) = selectedElement?.element {
                    ColorPicker(elementColor: Binding(get: {billboard.textColor}, set: { billboard.textColor = $0 }), sharedEditNotifier: SharedEditState())
                }
            case .transparencySlider:
                if let element = selectedElement {
                    TransparencySlider(transparency: Binding(get: {element.opacity}, set: {element.opacity = $0}))
                    //                            selectedElement?.changed = true
                    
                }
            case .colorPickerQuestionTxt:
                if case .question(let question) = selectedElement?.element {
                    ColorPicker(elementColor: Binding(get: {question.txtColor}, set: { question.txtColor = $0 }), sharedEditNotifier: SharedEditState())
                }
            case .colorPickerQuestionBG:
                if case .question(let question) = selectedElement?.element {
                    ColorPicker(elementColor: Binding(get: {question.bgColor}, set: { question.bgColor = $0 }), sharedEditNotifier: SharedEditState())
                }
            }
            
            HStack {
                if selectedElement == nil {
                    if !add {
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            BarButton(name: "music.note")
                        }
                        
                        Spacer()
                        
                        Button {
                            add.toggle()
                        } label: {
                            BarButton(name: "plus")
                        }
                        
                        Spacer()
                        
                        Button {
                            backgroundEdit = true
                        } label: {
                            BarButton(name: "rectangle.portrait.on.rectangle.portrait.fill")
                        }
                        
                        Spacer()
                        
                        
                    } else {
                        //                Button {
                        //                    displayPhotoPicker.toggle()
                        //
                        //                } label: {
                        //                    BarButton(name: "photo.fill")
                        //                }
                        
                        Button {
                            add.toggle()
                        } label: {
                            BarButton(name: "xmark")
                        }
                        
                        Spacer()
                        
                        ProfilePhotoPicker(parent: self)
                        
                        Spacer()
                        
                        Button {
                            profileAdd(shape: true)
                        } label: {
                            BarButton(name: "triangle.fill")
                        }
                        
                        Spacer()
                        
                        Button {
                            profileAdd(text: true)
                        } label: {
                            BarButton(name: "bubble.fill")
                        }
                        
                        Spacer()
                        
                        Button {
                            profileAdd(question: true)
                        } label: {
                            BarButton(name: "questionmark.bubble.fill")
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            BarButton(name: "rectangle.3.group.bubble.left.fill")
                        }
                    }
                } else {
                    
                    Button {
                        selectedElement = nil
                    } label: {
                        BarButton(name: "xmark")
                    }
                    
                    Spacer()
                    
                    Button {
                        selectedElement?.pinned.toggle()
                    } label: {
                        BarButton(name: "pin.fill")
                    }
                    
                    Spacer()
                    
                    if let element = selectedElement {
                        switch element.element {
                        case .image:
                            ImageBar(element: element, editorDisplayed: $editorDisplayed)
                        case .billboard:
                            BillboardBar(element: element)
                        case .poll(_):
                            Text("Murder them rasclats")
                        case .shape(_):
                            ShapeBar(element: element, editorDisplayed: $editorDisplayed)
                        case .question(_):
                            QuestionBar(element: element, editorDisplayed: $editorDisplayed)
                        case .video(_):
                            Text("Murder them rasclats")
                        }
                    }
                }
            }
            .padding()
            .background(Color.black)
        }
        .sheet(isPresented: $displayPhotoPicker) {
            ProfilePhotoPicker(parent: self)
        }
        .fullScreenCover(isPresented: $backgroundEdit) {
            Editor(isEditorActive: $backgroundEdit, sharedEditNotifier: SharedEditState(backgroundEdit: true, profileEdit: true))
        }
        
    }
    
    func profileAdd(image: UIImage? = nil, shape: Bool = false, text: Bool = false, question: Bool = false) {
        
        let elementID = "\(userUID)\(NSDate().timeIntervalSince1970)"
        
        if let image = image {
            let element = profileElementClass(id: elementID, element: .image(profileImageClass(offlineImage: image)), width: 6, height: 6, redirect: .post(""), pinned: false)
            classElementsArray.insert(element, at: 0)
        } else if shape {
            let element = profileElementClass(id: elementID, element: .shape(profileShapeClass(shape: 3, color: Color.black)), width: 6, height: 6, redirect: .post(""), pinned: false)
            classElementsArray.insert(element, at: 0)
        } else if text {
            let element = profileElementClass(id: elementID, element: .billboard(profileBillboardClass(text: "Text", font: "placeholder", textColor: Color.white, bgColor: Color.black)), width: 6, height: 6, redirect: .post(""), pinned: false)
            classElementsArray.insert(element, at: 0)
        } else if question {
            let element = profileElementClass(id: elementID, element: .question(profileQuestionClass(question: "Question", userResponses: [:], txtColor: Color.white, bgColor: Color.red)), width: 1, height: 6, redirect: .post(""), pinned: false)
            classElementsArray.insert(element, at: 0)
        }
        
        classElementsArray[0].changed = true
        
        classElementsArray[0].next = classElementsArray[1].id
        
        if classElementsArray.indices.contains(1) {
            classElementsArray[1].changed = true
            classElementsArray[1].previous = classElementsArray[0].id
        }
    }
    
    struct ProfilePhotoPicker: View {
        @State var selectedImages: [PhotosPickerItem] = []
        let parent: ProfileBar
        
        var body: some View {
            PhotosPicker(selection: $selectedImages, matching: .images) {
                BarButton(name: "photo.fill")
            }
            .onChange(of: selectedImages) { _ in
                Task {
                    // Retrieve selected asset in the form of Data
                    for newItem in selectedImages {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            let uiImage = UIImage(data: data)
                            parent.profileAdd(image: uiImage)
                        }
                    }
                    
                    selectedImages = []
                }
            }
        }
    }
    
    struct ImageBar: View {
        @ObservedObject var element: profileElementClass
        @Binding var editorDisplayed: EditorDisplayEnum
        
        var body: some View {
            
            Button {
                editorDisplayed = .transparencySlider
                element.changed = true
            } label: {
                BarButton(name: "square.dotted")
            }
            
            
            Spacer()
            
            Button {
                
            } label: {
                BarButton(name: "paperclip")
            }
            
        }
    }
    
    struct ShapeBar: View {
        @ObservedObject var element: profileElementClass
        @Binding var editorDisplayed: EditorDisplayEnum
        
        var body: some View {
            
            Button {
                editorDisplayed = .transparencySlider
                element.changed = true
            } label: {
                BarButton(name: "square.dotted")
            }
            
            Spacer()
            
            Button {
                
            } label: {
                BarButton(name: "paperclip")
            }
            
            Spacer()
            
            Button {
                    
                editorDisplayed = .colorPickerShape
                
                element.changed = true
                
                
            } label: {
                BarButton(name: "paintpalette.fill")
            }
        }
    }
    
    struct BillboardBar: View {
        @ObservedObject var element: profileElementClass
        
        var body: some View {
            
            Button {
                
            } label: {
                VStack (alignment: .center) {
                    BarButton(name: "paintpalette.fill")
                    
                    Text("Background")
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                VStack (alignment: .center) {
                    BarButton(name: "paintpalette.fill")
                    
                    Text("Text")
                }
            }
            
        }
    }
    
    struct QuestionBar: View {
        @ObservedObject var element: profileElementClass
        @Binding var editorDisplayed: EditorDisplayEnum
        
        var body: some View {
            Button {
                editorDisplayed = .colorPickerQuestionTxt
                element.changed = true
            } label: {
                
                    BarButton(name: "paintpalette.fill")
                        .overlay(
                            VStack {
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    
                                    Image(systemName: "character")
//                                        .scaleEffect(, anchor: .center)
                                        .foregroundStyle(.white)
                                        .background(Circle().foregroundStyle(.black))
                                }
                            }
                        )
                    
                    
                
            }
            
            Spacer()
            
            Button {
                editorDisplayed = .colorPickerQuestionBG
                element.changed = true
            } label: {
                BarButton(name: "paintpalette.fill")
            }
        
            
        }
    }
    
    enum EditorDisplayEnum {
        case none
        case colorPickerShape
        case colorPickerBillboardTxt
        case colorPickerBillboardBG
        case colorPickerQuestionTxt
        case colorPickerQuestionBG
        case transparencySlider
    }
    
}

struct BarButton: View {
    let name: String
    let buttonSize: CGFloat = 25
    
    var body: some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: buttonSize, height: buttonSize)
            .foregroundStyle(Color.white)
    }
}

//func asColor(red: Double, green: Double, blue: Double) -> Color {
//    return Color(red: red, green: green, blue: blue)
//}
//
//func backConversion(color: Color, to: [Double]) {
//    var red: CGFloat = 0
//    var green: CGFloat = 0
//    var blue: CGFloat = 0
//    var alpha: CGFloat = 0
//
//    UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//
//    to[0] = red
//    to[1] = green
//    to[2] = blue
//}




