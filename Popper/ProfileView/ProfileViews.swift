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
        .overlay(parent.selectedElement == element ? Rectangle()
            .stroke(Color.black, lineWidth: 5)
            .frame(width: sizeify(element: element).width,
                   height: sizeify(element: element).height) : nil
        )
        
        .onTapGesture(count: 2) {if parent.profileEdit {parent.selectedElement = element}}
        
//        .onLongPressGesture(perform: {
//            parent.selectedElement = element
//
//        })
            
        
        
        
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
    

}




