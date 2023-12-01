//
//  SwiftUIView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/27/23.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Rectangle()
            .frame(width: 100, height: 100)
            .foregroundStyle(Color.orange)
            .position(x: 200, y: -100)
        
        Rectangle()
            .frame(width: 100, height: 100)
            .foregroundStyle(Color.blue)
            .position(x: 200, y: 100)
    }
}

#Preview {
    SwiftUIView()
}
