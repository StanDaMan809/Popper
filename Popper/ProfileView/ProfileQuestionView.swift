//
//  okay.swift
//  Popper
//
//  Created by Stanley Grullon on 12/7/23.
//

import SwiftUI

struct ProfileQuestionView: View {
    @State var response: String = ""
    let edited: Bool
    @ObservedObject var question: profileQuestionClass
    @ObservedObject var element: profileElementClass
    
    var body: some View {
        VStack {
            
            if edited {
                TextField("Question", text: Binding(get: {question.question}, set: {question.question = $0}))
                    .foregroundStyle(question.txtColor)
                    .onTapGesture() {
                        element.changed = true
                    }
            } else {
                Text(question.question)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(question.txtColor)
            }
            
            TextField("Response...", text: $response)
                .foregroundStyle(question.txtColor)
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
//                        .stroke(((question.bgColor[0] + question.bgColor[1] + question.bgColor[2]) / 3 > 127.5) ? .black : .white, lineWidth: 1)
                        .stroke(Color.white)
                )
                .padding(.horizontal)
                .disabled(edited)
        }
        .padding()
        .frame(width: sizeify(element: element).width, height: sizeify(element: element).height)
        .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(question.bgColor))
        
    }
}
