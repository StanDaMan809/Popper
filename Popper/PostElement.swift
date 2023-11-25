//
//  PostElement.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI
import AVFoundation

struct PostElement: View {
    @ObservedObject var element: postElement
    @ObservedObject var elementsArray: postElementsArray
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        postElementView(element: element, elementsArray: elementsArray)
            .onTapGesture {
                if let soundToPlay = element.element.soundOnClick {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: soundToPlay)
                        audioPlayer?.play()
                    } catch {
                        print("Error playing audio: \(error.localizedDescription)")
                    }
                }
                
                // Make all displays linked to this one appear!
                for i in element.element.createDisplays
                {
                    print("Retrieving for \(i)...")
                    if let itemToDisplay = elementsArray.elements[i] {
                        itemToDisplay.element.display = true
                    } else { }// else if textArray blah blah blah
                }
                
                // Make all displays linked to this one disappear
                for i in element.element.disappearDisplays
                {
                    if let itemToDisplay = elementsArray.elements[i] {
                        itemToDisplay.element.display = false
                    } // else if textArray blah blah blah
                }
                
                // Summon the rewind button for editing
                if element.element.createDisplays.count != 0 || element.element.disappearDisplays.count != 0 {
//                    sharedEditNotifier.rewindButtonPresent = true Rewind Button has to be remade, I'll do it in a bit
                }
            }
    }
}
