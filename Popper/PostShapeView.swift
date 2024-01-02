//
//  PostShapeView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI
import UIKit

struct PostShapeView: View {
    @ObservedObject var shape: postShape
    
    var body: some View {
        if shape.display {
            Rectangle()
                .frame(width: shape.size.width, height: shape.size.height)
                .clipShape(shape.currentShape)
                .foregroundStyle(shape.color)
                .rotationEffect(shape.rotationDegrees)
                .scaleEffect(shape.scalar)
                .offset(shape.position)
                .opacity(shape.transparency)
            
        }
        
    }
    
}
