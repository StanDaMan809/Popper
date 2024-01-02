//
//  postRewindButton.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI

struct PostRewindButton: View {
    @Binding var elementsArray: [String : postElement]
    @Binding var displayRewind: Bool
    
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
        for (_, element) in elementsArray {
            element.display = element.defaultDisplaySetting
        }
        displayRewind = false
    }
}

