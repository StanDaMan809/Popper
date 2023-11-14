//
//  Trash.swift
//  Popper
//
//  Created by Stanley Grullon on 11/6/23.
//

import SwiftUI

struct Trash: View {
    
    
    
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View {
        
            VStack {
                
                Spacer()
                
                GeometryReader { geo in
                        Image(systemName: "trash")
                            .resizable()
                            .onAppear {
                                sharedEditNotifier.trashCanFrame = geo.frame(in: .global)
                            }
                            .offset(y: 50)
                }
                .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
                .frame(width: 50, height: 50, alignment: .center)
                
            }
            .padding(50)
//
//        .gesture(
//            DragGesture()
//                .onChanged { gesture in
//                    toDelete = trashCanFrame.contains(gesture.location)
//                }
//                .onEnded { gesture in
//                    
//                }
//        )
        
    }
}

//#Preview {
//    Trash()
//}

