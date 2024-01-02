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
    @Binding var elementsArray: [String : postElement]
    @Binding var displayRewind: Bool
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        postElementView(element: element)
            .onTapGesture {
                if let soundToPlay = element.soundOnClick {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: soundToPlay)
                        audioPlayer?.play()
                    } catch {
                        print("Error playing audio: \(error.localizedDescription)")
                    }
                }
                
                // Make all displays linked to this one appear!
                for i in element.createDisplays
                {
                    print("Retrieving for \(i)...")
                    if let itemToDisplay = elementsArray[i] {
                        itemToDisplay.display = true
                    } else { }// else if textArray blah blah blah
                }
                
                // Make all displays linked to this one disappear
                for i in element.disappearDisplays
                {
                    if let itemToDisplay = elementsArray[i] {
                        itemToDisplay.display = false
                    } // else if textArray blah blah blah
                }
                
                // Summon the rewind button for editing
                if element.createDisplays.count != 0 || element.disappearDisplays.count != 0 {
                    displayRewind = true
                }
            }
    }
}
