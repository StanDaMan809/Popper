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
    @Published var currentShape: ClippableShape = .roundedrectangle
    @Published var totalOffset: CGPoint = CGPoint(x: 0, y: 0)
    @Published var size: CGSize // Video's true specs, to not be touched
    @Published var scalar: CGFloat
    @Published var transparency: Double
    @Published var display: Bool
    @Published var createDisplays: [Int] = []
    @Published var disappearDisplays: [Int] = []
    @Published var rotationDegrees: Angle = Angle.zero
    @Published var soundOnClick: URL? 
    @Published var lock: Bool = false
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
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var currentAmount: Double
    @Binding var currentRotation: Angle

    var body: some View {
        if video.display {
            CustomVideoPlayer(videoURL: video.videoURL, play: $play)
                .frame(width: video.size.width, height: video.size.height)
                .clipShape(video.currentShape)
                .overlay(
                    Group {
                        if video.lock {
                            elementLock(id: video.id)
                        }
                    }
                )
                .rotationEffect(currentRotation + video.rotationDegrees)
                .scaleEffect(video.scalar + currentAmount)
                .position(video.totalOffset)
                .opacity(video.transparency)
                .zIndex(Double(video.id))
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

func videoAdd(vidURL: URL, size: CGSize, elementsArray: editorElementsArray, sharedEditNotifier: SharedEditState) {
    
    var defaultDisplaySetting = true
    
    if sharedEditNotifier.editorDisplayed == .photoAppear {
        if let currentElement = sharedEditNotifier.selectedElement {
            currentElement.element.createDisplays.append(elementsArray.objectsCount)
            defaultDisplaySetting = false
        }
        
    }
    
    elementsArray.elements[elementsArray.objectsCount] = editorElement(element: .video(editableVid(id: elementsArray.objectsCount, videoURL: vidURL, currentShape: .rectangle, totalOffset: CGPoint(x: 150, y: 500), size: size, scalar: 1.0, display: defaultDisplaySetting, transparency: 1, defaultDisplaySetting: defaultDisplaySetting)))
    
    elementsArray.objectsCount += 1
}
