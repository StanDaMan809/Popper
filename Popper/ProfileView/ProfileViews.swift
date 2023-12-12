//
//  ProfileElementView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/30/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileElementView: View {
    
    let parent: customProfileView
    @ObservedObject var element: profileElementClass
    
    var body: some View {
        Group{
            switch element.element {
                
            case .image(let image):
                if image.image != nil {
                    WebImage(url: image.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                        .clipShape(.roundedrectangle)
                        .clipped()
                        
                }
                
            case .billboard(let billboard):
                Text(billboard.text)
                    .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
                    .foregroundStyle(billboard.textColor)
                    .background(RoundedRectangle(cornerRadius: 15).frame(width: sizeify(element: element).width, height: sizeify(element: element).height).foregroundStyle(billboard.bgColor))
                
//                Text(billboard.text)
//                    .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
//                    .foregroundStyle(Color(red: billboard.textColor[0], green: billboard.textColor[1], blue: billboard.textColor[2]))
//                    .background(RoundedRectangle(cornerRadius: 15).frame(width: sizeify(element: element).width, height: sizeify(element: element).height).foregroundStyle(Color(red: billboard.bgColor[0], green: billboard.bgColor[1], blue: billboard.bgColor[2])))
                
            case .poll(let poll):
                Text("Shart")
                
            case .shape(let shape):
                
//                Rectangle()
//                    .clipShape(ClippableShape(rawValue: shape.shape) ?? .square)
//                    .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
//                    .foregroundStyle(shape.color)
                
                ProfileShapeClassView(shape: shape)
                    .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
                
            case .question(let question):
                
                ProfileQuestionView(edited: (parent.selectedElement == element), question: question, element: element)
                    

                
            case .video(let video):
                Text("Shart")
            }
        }
//        .overlay(parent.selectedElement == element ? Rectangle()
//            .stroke(Color.black, lineWidth: 5)
//            .frame(width: sizeify(element: element).width,
//                   height: sizeify(element: element).height) : nil
//        )
        .opacity(element.opacity)
        .overlay(parent.selectedElement == element ? ResizeArrows(element: element) : nil)
        
        .onTapGesture(count: 2) {if parent.profileEdit {parent.selectedElement = element}}
        
        .onTapGesture {
            if !parent.profileEdit {
                switch element.redirect {
                case .post(let postID):
                    Task {
                        if let postToRedirect = await downloadPost(postID: postID) {
                            parent.postToDisplay = postToRedirect
                            withAnimation {
                                parent.displayPost = true
                            }
                        }
                    }
                case .profile(let profileID):
                    return
                case .website(let link):
                    return
                }
            }
            
            
        }
        
        
        
    }
    
    struct ResizableSquare: View {
        @ObservedObject var element: profileElementClass // Initial width and height
        
        var body: some View {
            ZStack {
                VStack {
                    Rectangle()
                        .frame(height: 20)
                        .gesture(
                        DragGesture()
                            .onChanged { value in
                                
                                let widthIncrement = UIScreen.main.bounds.width / 9
                                
                                if abs(value.translation.height) > widthIncrement {
                                    if element.height >= 1, element.height <= 7 {
                                        withAnimation {
                                            element.height -= Int(value.translation.height / widthIncrement)
                                        }
                                    }
                                }
                                
                            }
                        )
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(height: 20)
                }
                
                HStack {
                    Rectangle()
                        .frame(width: 20)
                        .gesture(
                        DragGesture()
                            .onChanged { value in
                                
                                let widthIncrement = UIScreen.main.bounds.width / 9
                                
                                if abs(value.translation.width) > widthIncrement {
                                    if element.width >= 1, element.width <= 8 {
                                        
                                        let newValue = max(min(element.width + Int(value.translation.width / widthIncrement), 8), 1)
                                        
                                        withAnimation {
                                            element.width = newValue
                                        }
                                    }
                                }
                                
                            }
                        )
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(width: 20)
                        .gesture(
                        DragGesture()
                            .onChanged { value in
                                
                                let widthIncrement = UIScreen.main.bounds.width / 9
                                
                                if abs(value.translation.width) > widthIncrement {
                                    if element.width >= 1, element.width <= 8 {
                                        
                                        let newValue = max(min(element.width - Int(value.translation.width / widthIncrement), 8), 1)
                                        
                                        withAnimation {
                                            element.width = newValue
                                        }
                                    }
                                }
                                
                            }
                        )
                }
            }
                
        }
    }
    
    struct ResizeArrows: View {
        @ObservedObject var element: profileElementClass
        
        var body: some View {
            VStack {
                Button {
                    if element.height >= 2 {
                        element.height -= 1
                        element.changed = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        
                        .frame(width: 15, height: 15)
                        .padding(10)
                        .background(Circle().foregroundStyle(Color.gray).opacity(0.8))
                        
                }
                
                Spacer()
                
                HStack {
                    Button {
                        if element.width <= 7 {
                            element.width += 1
                            element.changed = true
                        }
                        
                    } label: {
                        Image(systemName: "minus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .padding(10)
                            .background(Circle().foregroundStyle(Color.gray).opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Button {
                        if element.width >= 2 {
                            element.width -= 1
                            element.changed = true
                        }
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(10)
                            .background(Circle().foregroundStyle(Color.gray).opacity(0.8))
                    }
                }
                
                Spacer()
                
                Button {
                    if element.height <= 7 {
                        element.height += 1
                        element.changed = true
                    }
                } label: {
                    Image(systemName: "minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .padding(10)
                        .background(Circle().foregroundStyle(Color.gray).opacity(0.8))
                }
                
            }
        }
    }
    
    
}

struct ProfileShapeClassView: View {
    @ObservedObject var shape: profileShapeClass
    
    var body: some View {
        Rectangle()
            .clipShape(ClippableShape(rawValue: shape.shape) ?? .square)
            .foregroundStyle(shape.color)
    }
}



