//
//  PostPollView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI
import UIKit

struct PostPollView: View {
    @ObservedObject var poll: postPoll
    @ObservedObject var elementsArray: postElementsArray
    
    var body: some View {
        if poll.display {
            onlinePollView(poll: poll)
                .rotationEffect(poll.rotationDegrees)
                .scaleEffect(poll.scalar)
                .position(poll.totalOffset)
                .opacity(poll.transparency)
                .zIndex(Double(poll.id)) // Controls layer
//            
//                .onTapGesture {
//                    for i in poll.createDisplays
//                    {
//                        imgArray.polls[i].display = true
//                    }
//                    
//                    for i in poll.disappearDisplays
//                    {
//                        imgArray.polls[i].display = false
//                    }
//                }
        }
        
    }
    
}

struct onlinePollView: View {
    
    @ObservedObject var poll: postPoll
    
    var body: some View {
        VStack
        {
            if poll.question != "" {
                ZStack {
                    VStack(spacing: 5) {
                        Text(poll.question)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .font(Font.custom("BarlowCondensed-Medium", size: 24))
                        
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(poll.topColor))
                    }
                    
                    
                }
                .background(bgForTop(color: $poll.topColor))
            }
            
            ForEach(Array(poll.responses.enumerated()), id: \.offset) { index, response in
                if response != "" {
                    Text(response)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .font(Font.custom("BarlowCondensed-Medium", size: 18))
                        .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(poll.buttonColor).opacity(0.2).padding(.horizontal))
                }
            }
            
        }
        .padding(.bottom)
        .padding(.top, poll.question == "" ? 10 : 0) // No padding at the top when the top is displaying
        .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(poll.bottomColor).opacity(0.8))
        .frame(width: 275)
    }
    
    struct bgForTop: View {
        @Binding var color: Color
        
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 15).foregroundStyle(color)
                    .offset(y: 10)
                Rectangle().foregroundStyle(color)
            }
        }
    }
}


// Handle the pollsArray data from post
class postPoll: ObservableObject {
    let id: Int
    let totalOffset: CGPoint
    let question: String
    var responses: [String]
    var topColor: Color
    var bottomColor: Color
    var buttonColor: Color
    let scalar: Double
    let rotationDegrees: Angle
    let transparency: Double
    @Published var display: Bool
    let defaultDisplaySetting: Bool
    
    init(poll: EditablePollData) {
        self.id = poll.id
        self.totalOffset = CGPoint(x: poll.totalOffset[0], y: poll.totalOffset[1])
        self.question = poll.question
        self.responses = poll.responses
        self.topColor = Color(red: poll.topColor[0], green: poll.topColor[1], blue: poll.topColor[2])
        self.bottomColor = Color(red: poll.bottomColor[0], green: poll.bottomColor[1], blue: poll.bottomColor[2])
        self.buttonColor = Color(red: poll.buttonColor[0], green: poll.buttonColor[1], blue: poll.buttonColor[2])
        self.scalar = poll.scalar
        self.rotationDegrees = Angle(degrees: poll.rotationDegrees)
        self.transparency = poll.transparency
        self.display = poll.defaultDisplaySetting
        self.defaultDisplaySetting = poll.defaultDisplaySetting
    }
}

struct EditablePollData: Codable, Equatable, Hashable {
    let id: Int
    let totalOffset: [Double]
    let question: String
    var responses: [String]
    var topColor: [Double]
    var bottomColor: [Double]
    var buttonColor: [Double]
    let scalar: Double
    let rotationDegrees: Double
    let transparency: Double
    let display: Bool
    let defaultDisplaySetting: Bool
    
    init(from editablePoll: editablePoll) {
        self.id = editablePoll.id
        
        self.totalOffset = [Double(editablePoll.totalOffset.x), Double(editablePoll.totalOffset.y)]
        // For encoding
        
        self.question = editablePoll.question
        
        if editablePoll.responses[0] == "" {
            editablePoll.responses[0] = "Yes"
        }
        
        if editablePoll.responses[1] == "" {
            editablePoll.responses[1] = "No"
        }
        
        self.responses = editablePoll.responses
        
        
        let buttonColor = UIColor(editablePoll.buttonColor)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        buttonColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.buttonColor = [red, green, blue]
        
        let topColor = UIColor(editablePoll.topColor)
        
        topColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.topColor = [red, green, blue]
        
        let bottomColor = UIColor(editablePoll.bottomColor)
        
        bottomColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.bottomColor = [red, green, blue]
        
        self.scalar = editablePoll.scalar
        self.transparency = editablePoll.transparency
        self.display = editablePoll.defaultDisplaySetting // If user uploads a post that's already interacted with, it'll upload just fine
        self.rotationDegrees = editablePoll.rotationDegrees.degrees
        self.defaultDisplaySetting = editablePoll.defaultDisplaySetting
    }
}


