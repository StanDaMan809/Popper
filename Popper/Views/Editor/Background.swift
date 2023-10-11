//
//  Background.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

struct Background: View {
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View {
        Color(.white)
            .onTapGesture {
                sharedEditNotifier.selectedImage = nil
                sharedEditNotifier.editorDisplayed = .none
                sharedEditNotifier.pressedButton = .noButton
            }
            .zIndex(-1)
    }
}
