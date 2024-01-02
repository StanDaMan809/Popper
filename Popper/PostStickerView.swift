//
//  PostStickerView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/19/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostStickerView: View {
    @ObservedObject var sticker: postSticker
    
    var body: some View {
        if sticker.display {
            WebImage(url: sticker.sticker)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(sticker.currentShape)
                .rotationEffect(sticker.rotationDegrees)
                .scaleEffect(sticker.scalar)
                .offset(sticker.position)
                .opacity(sticker.transparency)
        }
        
    }
    
}

