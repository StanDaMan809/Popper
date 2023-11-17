//
//  ExitConfirmation.swift
//  Popper
//
//  Created by Stanley Grullon on 11/14/23.
//

import SwiftUI

struct ExitConfirmation: View {
    var body: some View {
        
        VStack {
            Text("Are you sure you'd like to exit?")
                .font(.callout)
                .padding()
            
            HStack {
                Button {
                    
                } label: {
                    Text("Yes")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(.pink, in: Capsule())
                }
                
                Button {
                    
                } label: {
                    Text("No")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(.pink, in: Capsule())
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray))
    }
}



#Preview {
    ExitConfirmation()
}
