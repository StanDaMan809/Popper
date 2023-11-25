//
//  postElementView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI

struct postElementView: View {
    @ObservedObject var element: postElement
    @ObservedObject var elementsArray: postElementsArray
    
    var body: some View {
        switch element.element {
        case .image(let image):
            
            PostImageView(image: image, elementsArray: elementsArray)
            
        case .video(let video):
            
            PostVideoView(video: video, elementsArray: elementsArray)
            
        case .shape(let shape):
            
            PostShapeView(shape: shape, elementsArray: elementsArray)
            
        case .poll(let poll):
            
            PostPollView(poll: poll, elementsArray: elementsArray)
            
        case .sticker(let sticker):
            PostStickerView(sticker: sticker, elementsArray: elementsArray)
            
        }
    }
}

