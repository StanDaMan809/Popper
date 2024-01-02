//
//  sigh.swift
//  Popper
//
//  Created by Stanley Grullon on 12/23/23.
//

import SwiftUI

struct sigh: View {
    var body: some View {
        HStack {
            
            Spacer()
            
            Text("Please")
                .padding(.vertical, 10)
                .padding(.horizontal)
                .foregroundStyle(Color.white)
                .background(RoundedRectangle(cornerRadius: 25).foregroundStyle(Color.blue))
                .frame(maxWidth: 275, alignment: .trailing)
            
            
            
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    sigh()
}
