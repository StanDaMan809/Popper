//
//  okay.swift
//  Popper
//
//  Created by Stanley Grullon on 12/7/23.
//

import SwiftUI

struct ProfileQuestionView: View {
    @State var response: String = ""
    let question: profileQuestion
    
    var body: some View {
        VStack {
            Text(question.question)
                .foregroundStyle(Color(red: question.txtColor[0], green: question.txtColor[1], blue: question.txtColor[2]))
            
            TextField("Response...", text: $response)
                
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(((question.bgColor[0] + question.bgColor[1] + question.bgColor[2]) / 3 > 127.5) ? .black : .white, lineWidth: 1)
                )
                .padding(.horizontal)
        }
        .padding()
        
    }
}
