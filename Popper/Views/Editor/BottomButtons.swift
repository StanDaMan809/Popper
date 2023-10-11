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
    @ObservedObject var imgArray: imagesArray
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
            .tint(.black)
            .offset(x: -80)
            .padding()
            
            Button(action: {
                
            },
                   label: {
                    Image(systemName: "camera.aperture")
            })
            .scaleEffect(4)
            .tint(.black)
            .padding()
            
            Button(action: {
                
            },
                   label: {
                    Image(systemName: "arrowshape.right")
            })
            .scaleEffect(3)
            .tint(.black)
            .offset(x: 80)
            .padding()
            
        }
//        .offset(y: 335)
//        .frame(maxWidth: .infinity)
        .vAlign(.bottom)
        .padding(10)
    }
}
