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
    
    var body: some View {
        if poll.display {
            onlinePollView(poll: poll)
                .rotationEffect(poll.rotationDegrees)
                .scaleEffect(poll.scalar)
                .offset(poll.position)
                .opacity(poll.transparency)
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
                .background(bgForTop(color: poll.topColor))
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
        /*@Binding*/ var color: Color
        
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 15).foregroundStyle(color)
                    .offset(y: 10)
                Rectangle().foregroundStyle(color)
            }
        }
    }
}

