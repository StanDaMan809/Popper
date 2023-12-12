//
//  TransparencySlider.swift
//  Popper
//
//  Created by Stanley Grullon on 11/6/23.
//

import SwiftUI

struct TransparencySlider: View {
    @Binding var transparency: Double
    
    var body: some View {
        Slider(value: $transparency, in: 0.00001...1)
        .scaleEffect(0.90)
        .padding()
    }
}
