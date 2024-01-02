//
//  PostVideoView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI
import AVKit
import AVFoundation
import UIKit

struct PostVideoView: View {
    @ObservedObject var video: postVideo
    @State var play: Bool = true
    
    var body: some View {
        if video.display {
            CustomVideoPlayer(videoURL: video.videoURL, play: $play)
                .frame(width: video.size.width, height: video.size.height)
                .clipShape(video.currentShape)
                .rotationEffect(video.rotationDegrees)
                .scaleEffect(video.scalar)
                .offset(video.position)
                .opacity(video.transparency)
                .onAppear(perform: { play = true })
                .onDisappear(perform: { play = false })
                
    
        }
            
        
    }
    
}
