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
            Image(systemName: "backward.fill")
                .foregroundStyle(Color.black)
                .padding()
        }
    }
    
    func rewind() {
        for (_, element) in elementsArray.elements {
            element.element.display = element.element.defaultDisplaySetting
        }
        sharedEditNotifier.rewindButtonPresent = false 
    }
}
