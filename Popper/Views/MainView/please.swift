//
//  please.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI


struct please: View {
    
    var viewToBeSnapshotted: some View {
        Text("fuck off")
    }
    
    var body: some View {
        
        VStack {
            snapshot()
            
            Text("Hello!")
                .background(Circle().foregroundStyle(.blue))
        }
    }
    
    @MainActor func snapshot() -> Image {
        let imagerenderer = ImageRenderer(
            content: viewToBeSnapshotted
        )
        imagerenderer.scale = UIScreen.main.scale
        
        return Image(uiImage: imagerenderer.uiImage!)
    }
}

#Preview {
    please()
}
