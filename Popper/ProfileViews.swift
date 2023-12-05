//
//  ProfileElementView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/30/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileElementView: View {
    
    let element: profileElement
    
    var body: some View {
        switch element.element {
        case .image(let image):
            WebImage(url: image.image)
                .resizable()
                .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
                .scaledToFit()
        case .billboard(let billboard):
            Text(billboard.text)
                .foregroundStyle(Color(red: billboard.textColor[0], green: billboard.textColor[1], blue: billboard.textColor[2]))
                .background(RoundedRectangle(cornerRadius: 15).frame(width: sizeify(element: element).width, height: sizeify(element: element).height).foregroundStyle(Color(red: billboard.bgColor[0], green: billboard.bgColor[1], blue: billboard.bgColor[2])))
        case .poll(let poll):
            Text("Shart")
        case .question(let question):
            Text("Shart")
        case .video(let video):
            Text("Shart")
        }
    }
}

//#Preview {
//    ProfileViews()
//}
