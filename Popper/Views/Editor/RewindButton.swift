//
//  RewindButton.swift
//  Popper
//
//  Created by Stanley Grullon on 11/6/23.
//

import SwiftUI

struct RewindButton: View {
    @ObservedObject var elementsArray: editorElementsArray
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View {
        Button {
            rewind()
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(Color.black)
                    .opacity(0.4)
                    .frame(width: 30, height: 30)
                
                Image(systemName: "backward.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.white)
                    .frame(width: 15, height: 15)
            }
        }
    }
    
    func rewind() {
        for (_, element) in elementsArray.elements {
            element.element.display = element.element.defaultDisplaySetting
        }
        sharedEditNotifier.rewindButtonPresent = false 
    }
}
