//
//  imgElements.swift
//  Popper
//
//  Created by Stanley Grullon on 10/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

// Post view structure: contains all elements of the post

struct imgElements: View {
    
    var post: Post
    @State var elementsArray: [String : postElement] = [:]
    @State var displayRewind: Bool = false
    
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        ZStack
        {
            if displayRewind {
                HStack {
                    VStack
                    {
                        PostRewindButton(elementsArray: $elementsArray, displayRewind: $displayRewind)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
                .zIndex(1)
            }
            
            PostLayout(elementsArray: $elementsArray) {
                ZStack {
                    
                    
                    
                    // Call each element's data and create its view
                    ForEach(elementsArray.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                        if let itemToDisplay = elementsArray[key] {
                            PostElement(element: itemToDisplay, elementsArray: $elementsArray, displayRewind: $displayRewind)
                        }
                    }
                }
            }
        }
        
        .onAppear(perform: {
            for (key, value) in post.elementsArray {
                
                // This function might be completely redundant at this point, or maybe the post's element array needs to be cleared idk
                
//                elementsArray[key] = value
                
                switch value {
                    
                case .image(let element):
                    elementsArray[key] = element
                case .video(let element):
                    elementsArray[key] = element
                case .shape(let element):
                    elementsArray[key] = element
                case .poll(let element):
                    elementsArray[key] = element
                case .sticker(let element):
                    elementsArray[key] = element
                }
                
                // It's just implementing this shit as postElements, wiping everything away. which is really annoying 
                
            }
        })
    }
}
