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
    @ObservedObject var elementsArray: postElementsArray
    @State var play: Bool = true
    
    var body: some View {
        if video.display {
            CustomVideoPlayer(videoURL: video.videoURL, play: $play)
                .frame(width: video.size.width, height: video.size.height)
                .clipShape(video.currentShape)
                .rotationEffect(video.rotationDegrees)
                .scaleEffect(video.scalar)
                .position(video.totalOffset)
                .zIndex(Double(video.id)) // Controls layer
                .opacity(video.transparency)
    
        }
        
    }
    
}


// Handle the videosArray data from post
class postVideo: ObservableObject {
    let id: Int
    let videoURL: URL
    let currentShape: ClippableShape
    let totalOffset: CGPoint
    let size: CGSize
    let scalar: Double
    let transparency: Double
    @Published var display: Bool
    let rotationDegrees: Angle
    let createDisplays: [Int]
    let disappearDisplays: [Int]
    let linkOnClick: URL?
    let soundOnClick: URL?
    let defaultDisplaySetting: Bool
    let videoReferenceID: String
    
    init(video: EditableVideoData) {
        self.id = video.id
        self.videoURL = video.videoURL
        self.currentShape = ClippableShape(rawValue: video.currentShape) ?? .square
        self.totalOffset = CGPoint(x: video.totalOffset[0], y: video.totalOffset[1])
        self.size = CGSizeMake(video.size[0], video.size[1])
        self.scalar = video.scalar
        self.transparency = video.transparency
        self.display = video.defaultDisplaySetting
        self.rotationDegrees = Angle(degrees: video.rotationDegrees)
        self.createDisplays = video.createDisplays
        self.disappearDisplays = video.disappearDisplays
        self.linkOnClick = video.linkOnClick
        self.soundOnClick = video.soundOnClick
        self.defaultDisplaySetting = video.defaultDisplaySetting
        self.videoReferenceID = video.videoReferenceID
    }
}

struct EditableVideoData: Codable, Equatable, Hashable {
    let id: Int
    let currentShape: Int
    let totalOffset: [Double]
    let size: [Double]
    let scalar: Double
    let transparency: Double
    let display: Bool
    var createDisplays: [Int] = []
    var disappearDisplays: [Int] = []
    let rotationDegrees: Double
    let linkOnClick: URL?
    let soundOnClick: URL?
    let defaultDisplaySetting: Bool
    let videoURL: URL
    let videoReferenceID: String
    
    init(from editableVideo: editableVid, videoURL: URL, videoReferenceID: String) {
        self.id = editableVideo.id
        self.currentShape = editableVideo.currentShape.rawValue // For encoding
        self.totalOffset = [Double(editableVideo.totalOffset.x), Double(editableVideo.totalOffset.y)] // For encoding
        self.size = [Double(editableVideo.size.width), Double(editableVideo.size.height)] // For encoding
        self.scalar = editableVideo.scalar
        self.transparency = editableVideo.transparency
        self.display = editableVideo.defaultDisplaySetting // If user uploads a post that's already interacted with, it'll upload just fine
        self.createDisplays = editableVideo.createDisplays
        self.disappearDisplays = editableVideo.disappearDisplays
        self.rotationDegrees = editableVideo.rotationDegrees.degrees
        self.linkOnClick = editableVideo.linkOnClick
        self.soundOnClick = editableVideo.soundOnClick
        self.defaultDisplaySetting = editableVideo.defaultDisplaySetting
        self.videoURL = videoURL
        self.videoReferenceID = videoReferenceID
    }
}
