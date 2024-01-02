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

struct EditableVideo: View {
    @ObservedObject var video: editorVideo
    @State private var play: Bool = true
    @Binding var elementsArray: [String : editableElement]
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
                        if sharedEditNotifier.selectedElement?.id == video.id { Rectangle()
                                .stroke(Color.black, lineWidth: 5)
                        }
                        
                        if video.lock {
                            elementLock()
                        }
                    }
                )
                .rotationEffect(currentRotation + video.rotationDegrees)
                .scaleEffect(video.scalar + currentAmount)
                .offset(video.position)
                .opacity(video.transparency)
                .zIndex(sharedEditNotifier.textEdited() ? 0.0 : 1.0)
                .onDisappear(perform: {play = false})
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
