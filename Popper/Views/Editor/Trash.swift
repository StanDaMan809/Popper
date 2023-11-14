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
                            .offset(y: 50) // Workaround for the Geometry reader spawning 50 units below the actual trash can
                }
                .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
                .frame(width: 50, height: 50, alignment: .center)
                
            }
            .padding(50)
        
    }
}

