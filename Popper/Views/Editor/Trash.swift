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
                        ZStack {
                            Circle()
                                .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
                                .opacity(sharedEditNotifier.toDelete ? 1.0 : 0.8)
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.white)
                                .frame(width: 40, height: 40)
                                
                        }
                            .onAppear {
                                sharedEditNotifier.trashCanFrame = geo.frame(in: .global)
                                
                            }
                            .offset(y: 70) // Workaround for the Geometry reader spawning 70 units below the actual trash can
                }
                .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
                .frame(width: 70, height: 70, alignment: .center)
                
            }
            .ignoresSafeArea()
            .padding(70)
            
        
    }
}

