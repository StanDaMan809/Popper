//
//  please.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI


struct please: View {
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundStyle(Color.red)
                .frame(width: 100, height: 100)
                .position(x: 200, y: 0)
                
                
            
            Rectangle()
                .foregroundStyle(Color.blue)
                .frame(width: 100, height: 100)
                .position(x: 200, y: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        }
        
    }
}

#Preview {
    please()
}
