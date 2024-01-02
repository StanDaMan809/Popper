//
//  postElementView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI

struct postElementView: View {
    @ObservedObject var element: postElement
    
    var body: some View {
        
        if let image = element as? postImage
        {
            PostImageView(image: image)
        }
    
        else if let video = element as? postVideo
        {
            
            PostVideoView(video: video)
        }
        
        else if let shape = element as? postShape
        {
            
            PostShapeView(shape: shape)
        }
        
        else if let poll = element as? postPoll
        {
            PostPollView(poll: poll)
        }
        
        else if let sticker = element as? postSticker
        {
            PostStickerView(sticker: sticker)
        }
    }
}

