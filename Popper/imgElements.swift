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
    @ObservedObject var postImages: postImageArray // Gets called everytime imgOnPost is referenced
    
    var body: some View {
            ZStack {
                // Call each image's data and create its view
                
                ForEach(postImages.images.indices, id: \.self) {
                    index in
                    PostImageView(image: postImages.images[index], imgArray: postImages)
                }
                
                // Call each text's data and create its view
                
                ForEach(post.txtArray.indices, id: \.self) {
                    index in
                    postTextsView(from: post.txtArray[index])
                    
                    
                }
        }
    }
    
    init(post: Post) {
        self.post = post
        self.postImages = postImageArray(imagesArray: post.imagesArray)
    }
    
    // Handle the imagesArray data from post
    class postImage: ObservableObject {
        let id: Int
        let imgSrc: URL
        let currentShape: ClippableShape
        let totalOffset: [Double]
        let size: [Double]
        let scalar: Double
        let transparency: Double
        @Published var display: Bool
        let createDisplays: [Int]
        let disappearDisplays: [Int]
        let imageReferenceID: String
        
        init(image: EditableImageData) {
            self.id = image.id
            self.imgSrc = image.imageURL
            self.currentShape = ClippableShape(rawValue: image.currentShape) ?? .rectangle
            self.totalOffset = [image.totalOffset[0], image.totalOffset[1]]
            self.size = image.size
            self.scalar = image.scalar
            self.transparency = image.transparency
            self.display = image.display
            self.createDisplays = image.createDisplays
            self.disappearDisplays = image.disappearDisplays
            self.imageReferenceID = image.imageReferenceID
        }
    }
    
    class postImageArray: ObservableObject {
        @Published var images: [postImage] = []
        
        // Download images array from internet to this array
        // Necessary for disappearing / appearing eleemtns
        
        init(imagesArray: [EditableImageData]) {
            for image in imagesArray {
                self.images.append(postImage(image: image))
            }
        }
    }
    
    // Export imagesArray data to physical view
    // Distinct from imagesArray view for data saving, downloading + interaction purposes
    
    struct PostImageView: View {
        @ObservedObject var image: postImage
        @ObservedObject var imgArray: postImageArray
        
        var body: some View {
            if image.display {
                WebImage(url: image.imgSrc)
                    .resizable()
                    .frame(width: image.size[0], height: image.size[1])
                    .clipShape(image.currentShape)
                    .scaleEffect(image.scalar)
                    .position(CGPoint(x: image.totalOffset[0], y: image.totalOffset[1]))
                    .zIndex(Double(image.id)) // Controls layer
                    .opacity(image.transparency)
                
                    .onTapGesture {
                        for i in image.createDisplays
                        {
                            imgArray.images[i].display = true
                        }
                        
                        for i in image.disappearDisplays
                        {
                            imgArray.images[i].display = false
                        }
                    }
            }
            
        }
        
    }
    
    // Handle the txtArray data from post
    struct postTextsView: View {
        let id: Int
        let message: String
        let totalOffset: [Double]
        let color: Color
        let size: [Double]
        let scalar: Double
        let rotationDegrees: Double
        
        init(from textsArray: EditableTextData) {
            self.id = textsArray.id
            self.message = textsArray.message
            self.totalOffset = textsArray.totalOffset
            self.color = Color(red: textsArray.rValue, green: textsArray.gValue, blue: textsArray.bValue)
            self.size = textsArray.size
            self.scalar = textsArray.scalar
            self.rotationDegrees = textsArray.rotationDegrees
        }
        
        var body: some View {
            Text(message)
                // Text characteristics
                .font(.system(size: defaultTextSize))
                .frame(width: defaultTextFrame)
                .rotationEffect(Angle(degrees: rotationDegrees))
                .scaleEffect(scalar)
                .position(CGPoint(x: totalOffset[0], y: totalOffset[1]))
                .zIndex(Double(id)) // Controls layer
                .multilineTextAlignment(.center)
                .foregroundColor(color)
        }
    }
}
