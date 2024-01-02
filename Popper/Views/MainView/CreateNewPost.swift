//
//  CreateNewPost.swift
//  Popper
//
//  Created by Stanley Grullon on 10/9/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct CreateNewPost: View {
    // Callbacks
    var onPost: (Post)->()
    // post Properties
    
    @Binding var elementsArray: [String : editableElement]
    
    @State private var postText: String = ""
    @State private var postImageData: Data?
    
    // Stored user data from UserDefaults(AppStorage)
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    
    // View Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @FocusState private var showKeyboard: Bool
    
    @State private var visibility: Int = 1
    @State private var commentsEnabled: Bool = true
    @State private var allowSave: Bool = true
    @State private var saveAsPhoto: Bool = true
    
    // For text conversion to image! :D
    
    var body: some View {
        VStack {
            HStack {
                Button(role: .destructive){
                    dismiss()
                }
            label: {
                Text("Cancel")
                    .font(.callout)
            }
            .hAlign(.leading)
                
                Button{
                    createPost(elementsArray: elementsArray)
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
            
            Button {
                
            } label: {
                HStack {
                    Text("Visibility")
                        .hAlign(.leading)
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        .padding(15)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .padding(15)
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                    
                }
            }
            
            HStack {
                Text("Tag Friends")
                    .hAlign(.leading)
                    .padding(15)
            }
            
            Toggle("Enable Comments", isOn: $commentsEnabled)
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
    
    
    func createPost(elementsArray: [String : editableElement]) {
        isLoading = true
        showKeyboard = false
        Task {
            do {
                guard let profileURL = profileURL else { return }
                
                var elementsToUpload: [String : postEnum] = [:]
                
                for (key, element) in elementsArray {
                    
                    if let image = element as? editorImage {
                        
                        let imageReferenceID = "\(userUID)\(Date())\(image.id)\(key)" // Create Reference for each photo
                        let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID) // Create storage ref for each photo
                        if let data = image.imgSrc.pngData() { // Compression of each photo, to be finished soon
                            let _ = try await storageRef.putDataAsync(data)
                            let downloadURL = try await storageRef.downloadURL()
                            elementsToUpload[image.id] = .image(postImage(imgSrc: downloadURL, imageReferenceID: imageReferenceID, element: image))
                            
                        }
                    }
                    
                    else if let video = element as? editorVideo {
                        let videoReferenceID = "\(userUID)\(Date())\(video.id)\(key)" // Create Reference for each photo
                        let storageRef = Storage.storage().reference().child("Videos").child(videoReferenceID) // Create storage ref for each video
                        
                        do {
//                            // Convert video URL to Data
//                            let videoData = try Data(contentsOf: video.videoURL)
                            
                            // Upload video to Firebase Storage
                            let _ = try await storageRef.putFileAsync(from: video.videoURL)
                            
                            let downloadURL = try await storageRef.downloadURL()
                            
                            elementsToUpload[video.id] = .video(postVideo(videoURL: downloadURL, videoReferenceID: videoReferenceID, element: video))
                            
                            
                            
                        } catch {
                            print("Error uploading video.")
                        }
                    }
                    
                    
                    
                    else if let text = element as? editorText {
                        let imageReferenceID = "\(userUID)\(Date())\(text.id)\(key)"
                        let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID)
                        
                        if let conversionData = await snapshot(text: text), let data = conversionData.pngData() {
                            let _ = try await storageRef.putDataAsync(data)
                            let downloadURL = try await storageRef.downloadURL()
                            
                            let imageNumbers = postImage(imgSrc: downloadURL, imageReferenceID: imageReferenceID, element: textToEditableImg(text: text, image: conversionData))
                            
                            
                            elementsToUpload[text.id] = .image(imageNumbers)
                        }
                    }
                    
                    else if let shape = element as? editorShape
                    {
                        elementsToUpload[shape.id] = .shape(postShape(from: shape))
                    }
                    
                    else if let sticker = element as? editorSticker
                    {
                        elementsToUpload[sticker.id] = .sticker(postSticker(from: sticker))
                    }
                    
                    
                    //                        let imageReferenceID = "\(userUID)\(Date())\(sticker.id)\(key)" // Create Reference for each sticker
                    //                            let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID) // Create storage ref for each sticker
                    //
                    //                        do {
                    //                               // Download the sticker GIF data from the URL
                    //                               let data = try await URLSession.shared.data(from: sticker.url)
                    //
                    //                               // Upload the downloaded data to Firebase Storage
                    //                               let _ = try await storageRef.putDataAsync(data)
                    //
                    //                               // Get the download URL after uploading to Firebase Storage
                    //                               let downloadURL = try await storageRef.downloadURL()
                    //
                    //                               // Create EditableImageData and add it to elementsToUpload
                    //                               let imageNumbers = EditableImageData(from: sticker, imageURL: downloadURL, imageReferenceID: imageReferenceID)
                    //                               elementsToUpload[sticker.id] = EditableElementData(element: .image(imageNumbers))
                    //                           } catch {
                    //                               // Handle the error (e.g., network error, download failure)
                    //                               print("Error downloading or uploading sticker: \(error.localizedDescription)")
                    //                           }
                    
                    else if let poll = element as? editorPoll
                    {
                        elementsToUpload[poll.id] = .poll(postPoll(from: poll))
                    }
                    
                    
                }
                
                // Creating the thumbnail
                
                guard let conversionData = await thumbnail(elementsArray: elementsArray) else {return}
                
                guard let data = conversionData.pngData() else {return}
                
                let thumbnailReferenceID = "\(userUID)\(Date())"
                
                let storageRef = Storage.storage().reference().child("Thumbnails").child(thumbnailReferenceID)
                
                let _ = try await storageRef.putDataAsync(data)
                
                let downloadURL = try await storageRef.downloadURL()
                
                
                // Create Post object with all information
                
                let post = Post(text: postText, elementsArray: elementsToUpload, thumbnail: downloadURL, userName: userName, userUID: userUID, userProfileURL: profileURL, visibility: visibility, commentsEnabled: commentsEnabled, allowSave: allowSave)
                
                try await createDocumentAtFirebase(post)
                
                
                
            } catch {
                await setError(error)
            }
        }
    }
    
    //    func createDocumentAtFirebase(_ post: Post)async throws {
    //        // Writing Document to Firebase Firestore
    //        let doc = Firestore.firestore().collection("Posts").document()
    //        let _ = try await doc.setData(from: post, completion: { error in
    //            if error == nil {
    //                // Post Successfully Stored at Firebase
    //                isLoading = false
    //                var updatedPost = post
    //                updatedPost.id = doc.documentID
    //                onPost(updatedPost)
    //
    //                try elementToProfile(post: updatedPost)
    //
    //                // Dismiss View
    //                dismiss()
    //
    //            }
    //
    //        })
    //    }
    
    func createDocumentAtFirebase(_ post: Post) async {
        do {
            // Writing Document to Firebase Firestore
            let doc = Firestore.firestore().collection("Posts").document()
            try await doc.setData(from: post)
            
            // Post Successfully Stored at Firebase
            isLoading = false
            var updatedPost = post
            updatedPost.id = doc.documentID
            onPost(updatedPost)
            
            try await elementToProfile(post: updatedPost)
            
            // Dismiss View
            dismiss()
            
        } catch {
            print("Error writing document to Firestore: \(error.localizedDescription)")
            // Handle the error as needed
        }
    }
    
    
    func elementToProfile(post: Post) async throws {
        let nextFinder = try await Firestore.firestore().collection("Users").document(userUID).getDocument()
        var next: String?
        
        if let data = nextFinder.data(), let profileHead = data["profile"] as? [String : Any], let head = profileHead["head"] as? String {
            
            next = head
            
            
        } else {
            print("Error retrieving profile.head")
        }
        
        let elementID = "\(userUID)\(NSDate().timeIntervalSince1970)"
        
        let userDocRef = Firestore.firestore().collection("Users").document(userUID).collection("elements").document(elementID)
        
        // Create the element
        let newElement = profileElement(
            id: elementID,
            element: .image(profileImage(image: post.thumbnail)),
            width: 6,
            height: 6,
            redirect: .post(post.id ?? ""),
            pinned: false,
            next: next
        )
        
        do {
            // Attempt to set data for the new element
            try userDocRef.setData(from: newElement)
            
            print("check")
            
            let postedElement = userDocRef.documentID
            
            // Check if the collection is empty
            _ = try await Firestore.firestore().collection("Users").document(userUID).collection("elements").getDocuments()
            
            try await Firestore.firestore().collection("Users").document(userUID).setData(["profile" : ["head" : postedElement]], merge: true)
            
            print("set head element successfully. like i set it.")
            //            }
        } catch {
            print("Error updating document: \(error)")
        }
        
    }
    
    func setError(_ error: Error )async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
        
    }
    
    @MainActor func snapshot(text: editorText) -> UIImage? {
        let imagerenderer = ImageRenderer(
            
            content:
                
                Text(text.message)
                .font(text.font)
                .fontWeight(.bold)
                .foregroundColor(text.color)
                .padding()
                .background(
                    shapeForClippableShape(shape: text.currentShape)
                        .foregroundStyle(text.bgColor)
                )
                .multilineTextAlignment(.center)
        )
        imagerenderer.scale = UIScreen.main.scale
        
        return imagerenderer.uiImage
    }
    
}

@MainActor func thumbnail(elementsArray: [String : editableElement]) -> UIImage? {
    
    var peak = CGFloat.zero
    
    for (_, element) in elementsArray {
        
        peak = max(peak, ((element.size.height * element.scalar) / 2) + abs(element.position.height))
    }
    
    let imagerenderer = ImageRenderer(
        
        content:
            
            ZStack {
                
                Color.white
                    .frame(width: UIScreen.main.bounds.width, height: peak * 2)
                
                ForEach(elementsArray.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                    if let itemToDisplay = elementsArray[key] {
                        EditableElement(element: itemToDisplay, elementsArray: Binding(get: {elementsArray}, set: {$0}), sharedEditNotifier: SharedEditState())
                        
                    }
                    
                }
            }
    )
    imagerenderer.scale = UIScreen.main.scale
    
    return imagerenderer.uiImage
}

//struct CreateNewPost_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNewPost{_ in
//
//        }
//    }
//}
