//
//  DrawingView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/6/23.
//

import SwiftUI


struct DrawingView: View {
    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    @State private var paths: [Path] = []
    @State private var currentPath: Path = Path()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Canvas { context, size in
                    for path in paths {
                        context.stroke(path, with: .color(.blue), lineWidth: 5)
                    }
                    context.stroke(currentPath, with: .color(.blue), lineWidth: 5)
                }
                .drawingGroup()
                
                if !paths.isEmpty || !currentPath.isEmpty {
                    Color.clear  // Keeps the object there
                }
                
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let location = value.location
                        currentPath.addLine(to: location)
                    }
                    .onEnded { _ in
                        paths.append(currentPath)
                        currentPath = Path()
                        // imageadd ... etc etc. renderimagefromtpath current path. im just mentally tired
                    }
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
