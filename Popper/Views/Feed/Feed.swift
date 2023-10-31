//
//  Feed.swift
//  Popper
//
//  Created by Stanley Grullon on 4/6/23.
//

import SwiftUI

struct FeedPreview: PreviewProvider {
        static var previews: some View {
            Feed()
        }
    }

struct Feed: View {
    
    var body: some View {
        ZStack
        {
            FeedBG()
            userInfo()
            BottomUI()
        }
    }
}

struct BottomUI: View {
    
    var body: some View {
        HStack {
            Color.black
                .frame(width: 400, height: 75)
                .offset(y: 380)
        }
        
        HStack {
            Button(action:  {
                
            },
                   label: {
                Image(systemName: "house")
            })
            .padding()
            .tint(.white)
            .scaleEffect(1.9)
            Spacer()
            
            Button(action:  {
                
            },
                   label: {
                Image(systemName: "speaker")
            })
            .padding()
            .tint(.white)
            .scaleEffect(2.25)
            Spacer()
            
            Button(action:  {
                
            },
                   label: {
                Image(systemName: "plus.rectangle.portrait")
            })
            .rotationEffect(.degrees(90))
            .padding()
            .tint(.white)
            .scaleEffect(2.5)
            Spacer()
            
            Button(action:  {
                
            },
                   label: {
                Image(systemName: "message")
            })
            .padding()
            .tint(.white)
            .scaleEffect(2)
            Spacer()
            
            Button(action:  {
                
            },
                   label: {
                Image(systemName: "person")
            })
            .padding()
            .tint(.white)
            .scaleEffect(2.25)
        }
        .frame(maxWidth: .infinity)
        .offset(y: 370)
    }
}

struct FeedBG: View {
    
    var body: some View {
        Color.gray
            .zIndex(-1)
            .opacity(0.6)
    }
}

struct userInfo: View {
    
    var body: some View {
        ZStack {
            HStack
            {
                Button(action:  {
                    
                },
                       label: {
                    Image("Image")
                        .resizable()
                })
                .frame(width: 50, height: 50)
                .clipShape(.circle)
                
                Spacer()
                
                Button(action: {
                    
                },
                       label: {
                    Text("CallMeBeepMe47")
                        .padding(.leading)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                })
                .offset(x: -15)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .frame(alignment: .leading)
            .offset(x: 10, y: 240)
            
        }
        
        Text("Category... bad sister, I'm the bar.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .offset(x: 15, y: 285)
    }
}
