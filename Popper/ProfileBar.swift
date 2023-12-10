//
//  ProfileBar.swift
//  Popper
//
//  Created by Stanley Grullon on 12/7/23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ProfileBar: View {

    let userUID: String
    @State var add: Bool = false
    @State var displayPhotoPicker: Bool = false
    @Binding var profileElementsArray: [profileElement]
    @Binding var classElementsArray: [profileElementClass]
    @Binding var selectedElement: profileElementClass?
    
    var body: some View {
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
                        ImageBar(element: element)
                    case .billboard:
                        BillboardBar(element: element)
                    case .poll(_):
                        Text("Murder them rasclats")
                    case .shape(_):
                        ShapeBar(element: element)
                    case .question(_):
                        Text("Murder them rasclats")
                    case .video(_):
                        Text("Murder them rasclats")
                    }
                    }
            }
        }
        .padding()
        .background(Color.black)
        .sheet(isPresented: $displayPhotoPicker) {
            ProfilePhotoPicker(parent: self)
        }
        
    }
    
    func profileAdd(image: UIImage? = nil, shape: Bool = false, text: Bool = false, question: Bool = false) {
        
        let elementID = "\(userUID)\(NSDate().timeIntervalSince1970)"
        
        if let image = image {
            let element = profileElementClass(id: elementID, element: .image(profileImage(offlineImage: image)), width: 3, height: 3, redirect: .post(""), pinned: false)
            classElementsArray.insert(element, at: 0)
        } else if shape {
            let element = profileElementClass(id: elementID, element: .shape(profileShape(shape: 3, color: [0, 0, 0])), width: 3, height: 3, redirect: .post(""), pinned: false)
            classElementsArray.insert(element, at: 0)
        } else if text {
            let element = profileElementClass(id: elementID, element: .billboard(profileBillboard(text: "Text", font: "placeholder", textColor: [255, 255, 255], bgColor: [0, 0, 0])), width: 3, height: 3, redirect: .post(""), pinned: false)
            classElementsArray.insert(element, at: 0)
        } else if question {
            let element = profileElementClass(id: elementID, element: .question(profileQuestion(question: "Question", userResponses: [:], txtColor: [230, 230, 230], bgColor: [0, 0, 0])), width: 1, height: 3, redirect: .post(""), pinned: false)
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
        
        var body: some View {
            
            Button {
                
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
        
        var body: some View {

            Button {
                
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





