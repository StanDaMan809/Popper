//
//  PostTextsView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI

// Handle the txtArray data from post
struct postTextsView: View {
    let id: Int
    let message: String
    let totalOffset: [Double]
    let color: Color
    let size: [Double]
    let scalar: Double
    let rotationDegrees: Double
    
    init(from textsArray: EditableTextData) {
        self.id = textsArray.id
        self.message = textsArray.message
        self.totalOffset = textsArray.totalOffset
        self.color = Color(red: textsArray.rValue, green: textsArray.gValue, blue: textsArray.bValue)
        self.size = textsArray.size
        self.scalar = textsArray.scalar
        self.rotationDegrees = textsArray.rotationDegrees
    }
    
    var body: some View {
        Text(message)
            // Text characteristics
            .font(.system(size: defaultTextSize))
            .frame(width: defaultTextFrame)
            .rotationEffect(Angle(degrees: rotationDegrees))
            .scaleEffect(scalar)
            .position(CGPoint(x: totalOffset[0], y: totalOffset[1]))
            .zIndex(Double(id)) // Controls layer
            .multilineTextAlignment(.center)
            .foregroundColor(color)
    }
}

