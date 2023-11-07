//
//  Trash.swift
//  Popper
//
//  Created by Stanley Grullon on 11/6/23.
//

import SwiftUI

struct Trash: View {
    
    @State var isDeleting: Bool = false
    
    var body: some View {

        Image(systemName: isDeleting ? "trash.fill" : "trash")
            .padding()
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in DeleteElement() } )
    }
        
        
        func DeleteElement() {
            isDeleting.toggle()
            print("fucking kill me")
        }
    
}

#Preview {
    Trash()
}
