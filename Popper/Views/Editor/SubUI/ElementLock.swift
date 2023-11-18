//
//  ElementLock.swift
//  Popper
//
//  Created by Stanley Grullon on 11/14/23.
//

import SwiftUI

struct elementLock: View {
    
    let id: Int
    let small: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                   if !small {
                        Image(systemName: "lock.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundStyle(Color.white)
                            .zIndex(Double(id))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Circle().backgroundStyle(Color.gray).opacity(0.2))
                            
                   } else {
                       Image(systemName: "lock.fill")
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(width: 10, height: 10, alignment: .center)
                           .foregroundStyle(Color.white)
                           .zIndex(Double(id))
                           .padding(.vertical, 5)
                           .padding(.horizontal, 5)
                           .background(Circle().backgroundStyle(Color.gray).opacity(0.2))
                           
                   }
                
            }
            .vAlign(.top)
        }
    }
    
    init(id: Int, small: Bool = false) {
        self.id = id
        self.small = small
    }
}
