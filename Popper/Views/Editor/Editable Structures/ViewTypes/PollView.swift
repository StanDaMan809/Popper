//
//  PollView.swift
//  Popper
//
//  Created by Stanley Grullon on 11/17/23.
//

import SwiftUI

struct PollView: View {
    
    @ObservedObject var poll: editablePoll
    @State private var timer: Timer?
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View {
        VStack {
            if amISelected() {
                    ZStack {
                        VStack(spacing: 5) {
                            TextField("Ask a question...", text: $poll.question, axis: .vertical)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .foregroundStyle(.white)
                                .font(Font.custom("BarlowCondensed-Medium", size: 24))
                            
                                .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(poll.topColor))
                        }
                        .onTapGesture(count: 2) {
                            sharedEditNotifier.editorDisplayed = .colorPickerPollTop }

                        
                    }
                    .background(bgForTop(color: $poll.topColor))
                
            } else if poll.question != "" {
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
            
            textFieldForPoll(parent: self, placeholderText: "Yes", answer: $poll.responses[0], color: $poll.buttonColor)
            
            textFieldForPoll(parent: self, placeholderText: "No", answer: $poll.responses[1], color: $poll.buttonColor)
            
            if amISelected() {
                TextField("", text: $poll.responses[2], prompt: Text("Add an Answer...").foregroundColor(.white), axis: .vertical)
                    .lineLimit(2)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .font(Font.custom("BarlowCondensed-Medium", size: 18))
                    .foregroundStyle(Color.white)
                    .background(
                        TracedRectangle(parent: self, answer: $poll.responses[2], color: $poll.buttonColor)
                    )
            } else if poll.responses[2] != "" {
                Text(poll.responses[2])
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("BarlowCondensed-Medium", size: 18))
                    .background(nonTracedRectangle(parent: self, color: $poll.buttonColor))
            }
            
            if poll.responses[2] != "" && amISelected() {
                TextField("", text: $poll.responses[3], prompt: Text("Add an Answer...").foregroundColor(.white), axis: .vertical)
                    .lineLimit(2)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .font(Font.custom("BarlowCondensed-Medium", size: 18))
                    .foregroundStyle(Color.white)
                    .background(
                        TracedRectangle(parent: self, answer: $poll.responses[3], color: $poll.buttonColor)
                    )
            } else if poll.responses[2] != "" && poll.responses[3] != "" {
                Text(poll.responses[3])
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("BarlowCondensed-Medium", size: 18))
                    .background(nonTracedRectangle(parent: self, color: $poll.buttonColor))
            }
            
            
            
            
            
        }
        .padding(.bottom)
        .padding(.top, poll.question == "" && !amISelected() ? 10 : 0) // No padding at the top when the top is displaying
        .background(PollBackground(parent: self))
        .frame(width: 275)
        
        
    }
    
    struct TracedRectangle: View {
        
        let parent: PollView
        @Binding var answer: String
        @Binding var color: Color
        
        var body: some View {
            if answer == "" {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(Color.gray)
                    .padding(.horizontal)
            } else {
                nonTracedRectangle(parent: parent, color: $color)
            }
        }
    }
    
    struct nonTracedRectangle: View {
        
        let parent: PollView
        @Binding var color: Color
        
        var body: some View {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(color)
                .opacity(0.2)
                .padding(.horizontal)
                .onTapGesture(count: 2) {
                    if parent.amISelected() {
                        parent.sharedEditNotifier.editorDisplayed = .colorPickerPollButton
                    }
                }
        }
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
    
    struct textFieldForPoll: View {
        let parent: PollView
        let placeholderText: String
        @Binding var answer: String
        @Binding var color: Color
        
        var body: some View {
            if parent.amISelected() {
                TextField("", text: $answer, prompt: Text(placeholderText).foregroundColor(.white), axis: .vertical)
                    .lineLimit(2)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .font(Font.custom("BarlowCondensed-Medium", size: 18))
                    .background(nonTracedRectangle(parent: parent, color: $color))
                    .multilineTextAlignment(.leading)
            } else {
                Text(answer == "" ? placeholderText : answer)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("BarlowCondensed-Medium", size: 18))
                    .background(nonTracedRectangle(parent: parent, color: $color))
                    
            }
        }
    }
    
    struct PollBackground: View {
        let parent: PollView
        
        var body: some View {
            RoundedRectangle(cornerRadius: 15).foregroundStyle(parent.poll.bottomColor).opacity(0.8)
                .onTapGesture(count: 2) {
                    if parent.amISelected() {
                        parent.sharedEditNotifier.editorDisplayed = .colorPickerPollBG
                    }
                }
        }
    }
    
    func amISelected() -> Bool {
        if sharedEditNotifier.selectedElement?.element.id == poll.id {
            return true
        } else {
            return false
        }
    }
}
