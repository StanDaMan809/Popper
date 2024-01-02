//
//  PostImageView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostImageView: View {
    @ObservedObject var image: postImage
    
    var body: some View {
        if image.display {
            WebImage(url: image.url)
                .resizable()
                .frame(width: image.size.width*image.scalar, height: image.size.height*image.scalar)
                .clipShape(image.currentShape)
                .rotationEffect(image.rotationDegrees)
                .offset(image.position)
                .opacity(image.transparency)
        }
            
        
    }
    
}


