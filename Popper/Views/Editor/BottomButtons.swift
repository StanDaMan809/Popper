//
//  BottomButtons.swift
//  Popper
//
//  Created by Stanley Grullon on 10/10/23.
//

import SwiftUI

struct bottomButtons: View {
    @State private var showImagePicker = false
    @State var image: UIImage?
    @State private var newImageChosen = false
    @State private var createNewPost: Bool = false
    @State private var recentsPosts: [Post] = []
    @ObservedObject var imgArray: imagesArray
    @ObservedObject var txtArray: textsArray
    @ObservedObject var imgAdded: imageAdded
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View
    {
        HStack
        {
            // photo choosy button
            Button(action: {
                self.showImagePicker = true
            },
                   label: {
                    Image(systemName: "photo")
                
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(image: self.$image, showImagePicker: self.$showImagePicker, newImageChosen: self.$newImageChosen, imgArray: self.imgArray, imgAdded: self.imgAdded, sharedEditNotifier: self.sharedEditNotifier)
                        }
                    
                    
                
            })
            .scaleEffect(2.5)
            .tint(.white)
            .offset(x: -80)
            .padding()
            
            Button(action: {
                
            },
                   label: {
                    Image(systemName: "camera.aperture")
            })
            .scaleEffect(4)
            .tint(.white)
            .padding()
            
            Button(action: {
                createNewPost.toggle()
//                CreateNewPost(onPost: { post in
//                    recentsPosts.insert(post, at: 0)
//                }, imgArray: imgArray, txtArray: txtArray)
//                { post in
//                    recentsPosts.insert(post, at: 0)
//                }
            },
                   label: {
                    Image(systemName: "arrowshape.right")
            })
            .scaleEffect(3)
            .tint(.white)
            .offset(x: 80)
            .padding()
            .fullScreenCover(isPresented: $createNewPost) {
                CreateNewPost(onPost: { post in
                    // Adding created post at the top of the recent post
                    recentsPosts.insert(post, at: 0)
                }, imgArray: imgArray, txtArray: txtArray)
            }
            
        }
//        .offset(y: 335)
//        .frame(maxWidth: .infinity)
        .vAlign(.bottom)
        .padding(10)
    }
    
}
