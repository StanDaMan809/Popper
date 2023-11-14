//
//  EditableVideo.swift
//  Popper
//
//  Created by Stanley Grullon on 11/8/23.
//

import SwiftUI
import AVKit
import AVFoundation
import UIKit

class editableVid: Identifiable, ObservableObject {
    @Published var id: Int
    let videoURL: URL
    @Published var currentShape: ClippableShape = .rectangle
    @Published var totalOffset: CGPoint = CGPoint(x: 0, y: 0)
    @Published var size: CGSize // Video's true specs, to not be touched
    @Published var scalar: CGFloat
    @Published var transparency: Double
    @Published var display: Bool
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var rotationDegrees: Angle = Angle.zero
    let defaultDisplaySetting: Bool
    var startPosition: CGPoint

    init(id: Int, videoURL: URL, currentShape: ClippableShape, totalOffset: CGPoint, size: CGSize, scalar: CGFloat, display: Bool, transparency: Double, defaultDisplaySetting: Bool) {
        self.id = id
        self.videoURL = videoURL
        self.currentShape = currentShape
        self.totalOffset = totalOffset
        self.size = size
        self.scalar = scalar
        self.startPosition = totalOffset // initialize startPosition by equating it to totalOffset
        self.display = display
        self.transparency = transparency
        self.defaultDisplaySetting = defaultDisplaySetting
    }
}

struct EditableVideo: View {
    @ObservedObject var video: editableVid
    @State private var play: Bool = true
    @ObservedObject var elementsArray: editorElementsArray
    @State var currentAmount = 0.0
    @ObservedObject var sharedEditNotifier: SharedEditState
    @GestureState var currentRotation = Angle.zero

    var body: some View {
        if video.display {
            CustomVideoPlayer(videoURL: video.videoURL, play: $play)
                .frame(width: video.size.width, height: video.size.height)
                .clipShape(video.currentShape)
                .rotationEffect(currentRotation + video.rotationDegrees)
                .scaleEffect(video.scalar + currentAmount)
                .position(video.totalOffset)
                .opacity(video.transparency)
                .zIndex(Double(video.id))
            
                .onTapGesture(count: 2) {
                    video.currentShape = video.currentShape.next
                }
            
                .onTapGesture
                {
                    if sharedEditNotifier.editorDisplayed == .photoDisappear {
                        sharedEditNotifier.selectedImage?.disappearDisplays.append(self.video.id)
                        sharedEditNotifier.editorDisplayed = .none
                    }
                    
                    else
                    {
                            // Make all displays linked to this one appear!
                            for i in video.createDisplays
                            {
                                print("Retrieving for \(i)...")
                                if let itemToDisplay = elementsArray.elements[i] {
                                    itemToDisplay.element.display = true
                                } else { }// else if textArray blah blah blah
                            }
                            
                            // Make all displays linked to this one disappear
                            for i in video.disappearDisplays
                            {
                                if let itemToDisplay = elementsArray.elements[i] {
                                    itemToDisplay.element.display = false
                                } // else if textArray blah blah blah
                            }
                        
                        // Summon the rewind button for editing
                        if video.createDisplays.count != 0 || video.disappearDisplays.count != 0 {
                            sharedEditNotifier.rewindButtonPresent = true
                        }
                    }
                    
                    
//                    }
                }
            
                .gesture(
                    DragGesture() // Have to add UI disappearing but not yet
                        .onChanged { gesture in
//                            let scaledWidth = video.size[0] * CGFloat(video.scalar)
//                            let scaledHeight = video.size[1] * CGFloat(video.scalar)
//                            let halfScaledWidth = scaledWidth / 2
//                            let halfScaledHeight = scaledHeight / 2
                            let newX = gesture.location.x
                            let newY = gesture.location.y
                            video.totalOffset = CGPoint(x: newX, y: newY)
                            sharedEditNotifier.currentlyEdited = true
                            sharedEditNotifier.toDelete = sharedEditNotifier.trashCanFrame.contains(gesture.location)
                            sharedEditNotifier.editToggle()
                                    }
                    
                        .onEnded { gesture in
                            if sharedEditNotifier.trashCanFrame.contains(gesture.location) {
                                deleteElement(elementsArray: elementsArray, id: video.id)
                            } else {
                                video.startPosition = video.totalOffset
                            }
                            sharedEditNotifier.currentlyEdited = false
                            sharedEditNotifier.editToggle()
                        })
            
                .gesture(
                SimultaneousGesture( // Rotating and Size change
                        RotationGesture()
                        .updating($currentRotation) { value, state, _ in state = value
                            }
                        .onEnded { value in
                            video.rotationDegrees += value
                        },
                    MagnificationGesture()
                        .onChanged { amount in
                            currentAmount = amount - 1
                            sharedEditNotifier.currentlyEdited = true
                            sharedEditNotifier.editToggle()
                        }
                        .onEnded { amount in
                            video.scalar += currentAmount
                            currentAmount = 0
                            sharedEditNotifier.currentlyEdited = false
                            sharedEditNotifier.editToggle()
                            
                        }))
        }
    }
}

struct CustomVideoPlayer: UIViewControllerRepresentable {
    var videoURL: URL
    @Binding var play: Bool

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        // Disable the playback controls
        controller.showsPlaybackControls = false
        
        // Create an AVPlayer and loop it
        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVQueuePlayer(playerItem: playerItem)
        context.coordinator.looper = AVPlayerLooper(player: player, templateItem: playerItem)

        controller.player = player
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if play {
            uiViewController.player?.play()
        } else {
            uiViewController.player?.pause()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: CustomVideoPlayer
        var looper: AVPlayerLooper?

        init(_ parent: CustomVideoPlayer) {
            self.parent = parent
        }
    }
}
