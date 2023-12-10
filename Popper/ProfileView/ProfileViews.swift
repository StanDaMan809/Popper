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
                        .clipShape(.roundedrectangle)
                        .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
                        .scaledToFit()
                }
                
                if let image = image.offlineImage {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(.roundedrectangle)
                        .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
                        .scaledToFit()
                }
                
            case .billboard(let billboard):
                Text(billboard.text)
                    .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
                    .foregroundStyle(Color(red: billboard.textColor[0], green: billboard.textColor[1], blue: billboard.textColor[2]))
                    .background(RoundedRectangle(cornerRadius: 15).frame(width: sizeify(element: element).width, height: sizeify(element: element).height).foregroundStyle(Color(red: billboard.bgColor[0], green: billboard.bgColor[1], blue: billboard.bgColor[2])))
                
            case .poll(let poll):
                Text("Shart")
                
            case .shape(let shape):
                Rectangle()
                    .clipShape(ClippableShape(rawValue: shape.shape) ?? .square)
                    .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
                    .foregroundStyle(Color(red: shape.color[0], green: shape.color[1], blue: shape.color[2]))
                
            case .question(let question):
                ProfileQuestionView(question: question)
                    .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color(red: question.bgColor[0], green: question.bgColor[1], blue: question.bgColor[2])))
                
            case .video(let video):
                Text("Shart")
            }
        }
//        .overlay(parent.selectedElement == element ? Rectangle()
//            .stroke(Color.black, lineWidth: 5)
//            .frame(width: sizeify(element: element).width,
//                   height: sizeify(element: element).height) : nil
//        )
        
        .overlay(parent.selectedElement == element ? ResizeArrows(element: element) : nil)
        
        .onTapGesture(count: 2) {if parent.profileEdit {parent.selectedElement = element}}
        
        
        
        
        
    }
    
    //    private func handleDrag(value: DragGesture.Value, element: profileElement) {
    //        let horizontalRatio = value.startLocation.x / sizeify(element: element).width
    //        let verticalRatio = value.startLocation.y / sizeify(element: element).height
    //
    //        if value.translation.width > 0 && element.width > 1 {
    //            // Drag outward horizontally
    //            element.width -= 1
    //        } else if value.translation.width < 0 && element.width < 7 {
    //            // Drag inward horizontally
    //            element.width += 1
    //        }
    //
    //        if value.translation.height > 0 && element.height > 1 {
    //            // Drag outward vertically
    //            element.height -= 1
    //        } else if value.translation.height < 0 && element.height < 7 {
    //            // Drag inward vertically
    //            element.height += 1
    //        }
    //    }
    
    struct ResizableSquare: View {
        @ObservedObject var element: profileElementClass // Initial width and height
        
        var body: some View {
//            GeometryReader { geometry in
//                Rectangle()
//                    .frame(width: CGFloat(element.width) * geometry.size.width / 7, height: CGFloat(element.height) * geometry.size.height / 7)
//                    .foregroundColor(.blue)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                let deltaWidth = value.translation.width
//                                let deltaHeight = value.translation.height
//
//                                // Update width and height within the range [1, 7]
//                                if (1...7).contains(element.width - Int(deltaWidth)) {
//                                    element.width -= Int(deltaWidth)
//                                }
//
//                                if (1...7).contains(element.height + Int(deltaHeight)) {
//                                    element.height += Int(deltaHeight)
//                                }
//                            }
//                    )
//            }
            
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




