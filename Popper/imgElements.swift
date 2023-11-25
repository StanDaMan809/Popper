//
//  imgElements.swift
//  Popper
//
//  Created by Stanley Grullon on 10/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

// Post view structure: contains all elements of the post

struct imgElements: View {
    
    var post: Post
    @StateObject var elementsArray: postElementsArray = postElementsArray()
    
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        ZStack {
            // Call each element's data and create its view
            ForEach(elementsArray.elements.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                if let itemToDisplay = elementsArray.elements[key] {
                    PostElement(element: itemToDisplay, elementsArray: elementsArray)
                    
                }
            }
        }
        .onAppear(perform: {
            for (key, value) in post.elementsArray {
                
                switch value.element {
                case .image(let image):
                    elementsArray.elements[key] = postElement(element: .image(postImage(image: image)))
                case .video(let video):
                    elementsArray.elements[key] = postElement(element: .video(postVideo(video: video)))
                case .shape(let shape):
                    elementsArray.elements[key] = postElement(element: .shape(postShape(shape: shape)))
                case .poll(let poll):
                    elementsArray.elements[key] = postElement(element: .poll(postPoll(poll: poll)))
                case .sticker(let sticker):
                    elementsArray.elements[key] = postElement(element: .sticker(postSticker(sticker: sticker)))
                }
            }
        })
    }
    
    
}
