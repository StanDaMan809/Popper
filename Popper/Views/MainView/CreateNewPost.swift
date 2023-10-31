//
//  CreateNewPost.swift
//  Popper
//
//  Created by Stanley Grullon on 10/9/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct CreateNewPost: View {
    // Callbacks
    var onPost: (Post)->()
    // post Properties
    
    @ObservedObject var imgArray: imagesArray = imagesArray()
    @ObservedObject var txtArray: textsArray = textsArray()
    
    @State private var postText: String = ""
    @State private var postImageData: Data?
    
    // Stored user data from UserDefaults(AppStorage)
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    
    // View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @FocusState private var showKeyboard: Bool
    
    @State private var enableComments: Bool = true
    @State private var allowSave: Bool = true
    @State private var saveAsPhoto: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Button(role: .destructive){
                        dismiss()
                    }
                 label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .hAlign(.leading)
                
                Button{
                    createPost(imagesArrayInstance: imgArray, textsArrayInstance: txtArray)
                } label: {
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
                    TextField("What's happening?", text: $postText, axis: .vertical)
                        .focused($showKeyboard)
                }
                .padding(15)
            }
            .frame(height: 100)
            
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
            
        }
        .vAlign(.top)
        
        
        // Loading view
        
        .overlay {
            LoadingView(show: $isLoading)
        }
    }
    
    
    func createPost(imagesArrayInstance: imagesArray, textsArrayInstance: textsArray) {
        isLoading = true
        showKeyboard = false
        Task {
            do {
                guard let profileURL = profileURL else { return }
                
                // Photo Upload and Transcription
                var imagesData: [EditableImageData] = []
                for (index, image) in imagesArrayInstance.images.enumerated() {
                    let imageReferenceID = "\(userUID)\(Date())\(image.id)\(index)" // Create Reference for each photo
                    let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID) // Create storage ref for each photo
                    if let data = image.imgSrc.jpegData(compressionQuality: 1.0) { // Compression of each photo, to be finished soon
                        let _ = try await storageRef.putDataAsync(data)
                        let downloadURL = try await storageRef.downloadURL()
                        let imageNumbers = EditableImageData(from: image, imageURL: downloadURL, imageReferenceID: imageReferenceID)
                        imagesData.append(imageNumbers)
                    }
                }

                // Text Handling
                var textsToUpload = [EditableTextData]()
                for txt in textsArrayInstance.texts {
                    textsToUpload.append(EditableTextData(from: txt))
                }

                // Create Post object with all information
                
                let post = Post(text: postText, txtArray: textsToUpload, imagesArray: imagesData, userName: userName, userUID: userUID, userProfileURL: profileURL)
                try await createDocumentAtFirebase(post)
            } catch {
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ post: Post)async throws {
        // Writing Document to Firebase Firestore
        let doc = Firestore.firestore().collection("Posts").document()
        let _ = try doc.setData(from: post, completion: { error in
            if error == nil {
                // Post Successfully Stored at Firebase
                isLoading = false
                var updatedPost = post
                updatedPost.id = doc.documentID
                onPost(updatedPost)
                dismiss()
            }
            
        })
    }
    
    func setError(_ error: Error )async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
        
    }
}

struct CreateNewPost_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPost{_ in
            
        }
    }
}
