//
//  PostConfirmation.swift
//  Popper
//
//  Created by Stanley Grullon on 10/11/23.
//

import SwiftUI

struct PostConfirmation: View {
    
    @State private var caption: String = ""
    @State private var enableComments: Bool = true
    @State private var allowSave: Bool = true
    @State private var saveAsPhoto: Bool = true
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack {
            HStack {
                Menu {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                } label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .hAlign(.leading)
                
                Button(action: {}){
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(.pink, in: Capsule())
                    
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                Rectangle()
                        .fill(.pink.opacity(0.05))
                        .ignoresSafeArea()
                    
        }
                
        ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15){
                        TextField("Enter your caption...", text: $caption, axis: .vertical)
                            .focused($showKeyboard)
                    }
                    .padding(15)
                    
                }
            .frame(height: 75)
            
            Divider()
        
            HStack {
                Text("Visibility")
                    .hAlign(.leading)
                    .padding(15)
            }
            
            HStack {
                Text("Tag Friends")
                    .hAlign(.leading)
                    .padding(15)
            }
            
            Toggle("Enable Comments", isOn: $enableComments)
                .hAlign(.leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                
            
            Toggle("Allow Save", isOn: $allowSave)
                .hAlign(.leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
            
            Toggle("Save as Photo", isOn: $saveAsPhoto)
                .hAlign(.leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
            
//            Divider()
                
//            HStack {
//                    Button {
//
//                    }  label: {
//                        Image(systemName: "photo.on.rectangle")
//                            .font(.title3)
//                    }
//                    .hAlign(.leading)
//
//                    Button("Done") {
//                        showKeyboard = false
//                    }
//                }
//                .foregroundColor(.black)
//                .padding(.horizontal, 15)
//                .padding(.vertical, 10)
//                .vAlign(.bottom)
                
            }
        .vAlign(.top)
        }
}

struct PostConfirmation_Previews: PreviewProvider {
    static var previews: some View {
        PostConfirmation()
    }
}
