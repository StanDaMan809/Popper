//
//  imsobbing.swift
//  Popper
//
//  Created by Stanley Grullon on 11/22/23.
//

import SwiftUI
import WrappingHStack

struct imsobbing: View {
    
    
    var body: some View  {
        ScrollView(.vertical) {
            HStack {
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.red)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.blue)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.green)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.red)
                
                Spacer()
                
            }
            
            HStack {
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: UIScreen.main.bounds.width * (0.72), height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.pink)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.purple)
                
                Spacer()
                
                
            }
            
            HStack {
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.pink)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: UIScreen.main.bounds.width / 2.1, height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.gray)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.purple)
                
                Spacer()
                
                
            }
            
            
            HStack {
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.brown)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.red)
                
                Spacer()
                
                
                
            }
            
            
            HStack {
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.orange)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.pink)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.purple)
                
                Spacer()
                
                
            }
            
        }
    }
}

struct imsobbinggrid: View {
    
    let sizeOne = UIScreen.main.bounds.width - 10
    let sizeTwo = (UIScreen.main.bounds.width - 15) / 2
    let sizeThree = (UIScreen.main.bounds.width - 20) / 3
    let sizeFour = (UIScreen.main.bounds.width - 25) / 4
    let sizeFive = (UIScreen.main.bounds.width - 30) / 5
    let sizeWtf = UIScreen.main.bounds.width - 20 - 2 * ((UIScreen.main.bounds.width - 30) / 5)
    let sizeWtf2 = UIScreen.main.bounds.width - 15 - ((UIScreen.main.bounds.width - 25) / 4)
    
    var body: some View  {
        ScrollView(.vertical) {
            WrappingHStack(alignment: .center, horizontalSpacing: 5, verticalSpacing: 5, fitContentWidth: true) {
                    
                RoundedRectangle(cornerRadius: 15)
            .frame(width: sizeFour, height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.red)
                
                        RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFour, height: UIScreen.main.bounds.width / 2)
                            .foregroundStyle(Color.red)
                        
                        RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFour, height: UIScreen.main.bounds.width / 2)
                            .foregroundStyle(Color.blue)
                        
                        RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFour, height: UIScreen.main.bounds.width / 2)
                            .foregroundStyle(Color.green)
                        
//                        RoundedRectangle(cornerRadius: 15)
//                    .frame(width: sizeFour, height: UIScreen.main.bounds.width / 2)
//                            .foregroundStyle(Color.red)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeWtf2, height: sizeThree)
                    .foregroundStyle(Color.red)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFour, height: sizeThree)
                    .foregroundStyle(Color.red)
                    
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: sizeOne, height: sizeOne)
                        .foregroundStyle(Color.pink)
                    
                    RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeTwo, height: UIScreen.main.bounds.width / 2)
                        .foregroundStyle(Color.purple)
                    
                    RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeTwo, height: UIScreen.main.bounds.width / 2)
                        .foregroundStyle(Color.pink)
                    
                    RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFour, height: UIScreen.main.bounds.width / 2)
                        .foregroundStyle(Color.purple)
                    
                    RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeTwo, height: UIScreen.main.bounds.width / 2)
                        .foregroundStyle(Color.brown)
                    
                    RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFour, height: UIScreen.main.bounds.width / 2)
                        .foregroundStyle(Color.red)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeTwo, height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.gray)
                    
                    RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFour, height: UIScreen.main.bounds.width / 2)
                        .foregroundStyle(Color.orange)
                    
                    RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFour, height: UIScreen.main.bounds.width / 2)
                        .foregroundStyle(Color.pink)
                
                RoundedRectangle(cornerRadius: 15)
                .frame(width: sizeFive, height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.pink)
                
                RoundedRectangle(cornerRadius: 15)
                .frame(width: sizeWtf, height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.pink)
                
                RoundedRectangle(cornerRadius: 15)
                .frame(width: sizeFive, height: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(Color.pink)
                
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFive, height: sizeFive)
                    .foregroundStyle(Color.red)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFive, height: sizeFive)
                    .foregroundStyle(Color.red)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFive, height: sizeFive)
                    .foregroundStyle(Color.red)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFive, height: sizeFive)
                    .foregroundStyle(Color.red)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: sizeFive, height: sizeFive)
                    .foregroundStyle(Color.red)
                    
            }
            
        }
    }
}

#Preview {

    
    imsobbinggrid()
    
}
