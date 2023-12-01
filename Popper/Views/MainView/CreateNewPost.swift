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
    
    @ObservedObject var elementsArray: editorElementsArray = editorElementsArray()
    
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
                        .foregroundColor(.black)
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
                        .foregroundStyle(.black)
                        .padding(15)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                        .padding(15)
                    
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
    
    
    func createPost(elementsArray: editorElementsArray) {
        isLoading = true
        showKeyboard = false
        Task {
            do {
                guard let profileURL = profileURL else { return }
                
                
                // Photo Upload and Transcription
                var textsToUpload = [EditableTextData]()
                
                var elementsToUpload = [Int : EditableElementData]()
                
                for (key, element) in elementsArray.elements {
                    switch element.element {
                    
                    case .image(let image):
                            let imageReferenceID = "\(userUID)\(Date())\(image.id)\(key)" // Create Reference for each photo
                            let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID) // Create storage ref for each photo
                            if let data = image.imgSrc.pngData() { // Compression of each photo, to be finished soon
                                let _ = try await storageRef.putDataAsync(data)
                                let downloadURL = try await storageRef.downloadURL()
                                let imageNumbers = EditableImageData(from: image, imageURL: downloadURL, imageReferenceID: imageReferenceID)
                                
                                elementsToUpload[image.id] = EditableElementData(element: .image(imageNumbers))
                                
                        }
                        
                    case .video(let video):
                        let videoReferenceID = "\(userUID)\(Date())\(video.id)\(key)" // Create Reference for each photo
                        let storageRef = Storage.storage().reference().child("Videos").child(videoReferenceID) // Create storage ref for each video
                        
                        do {
                            // Convert video URL to Data
                            let videoData = try Data(contentsOf: video.videoURL)
                            
                            // Upload video to Firebase Storage
                            let _ = try await storageRef.putDataAsync(videoData)
                            
                            let downloadURL = try await storageRef.downloadURL()
                            
                            let videoNumbers = EditableVideoData(from: video, videoURL: downloadURL, videoReferenceID: videoReferenceID)
                            
                            elementsToUpload[video.id] = EditableElementData(element: .video(videoNumbers))
                            
                        } catch {
                            print("Error uploading video.")
                        }
                            
                    case .text(let text):
                        
                        let imageReferenceID = "\(userUID)\(Date())\(text.id)\(key)"
                        let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID)
                        
                        if let conversionData = snapshot(text: text), let data = conversionData.jpegData(compressionQuality: 0.8) {
                            let _ = try await storageRef.putDataAsync(data)
                            let downloadURL = try await storageRef.downloadURL()
                            let imageNumbers = EditableImageData(from: textToEditableImg(text: text, image: conversionData), imageURL: downloadURL, imageReferenceID: imageReferenceID)
                            
                            elementsToUpload[text.id] = EditableElementData(element: .image(imageNumbers))
                        }
                    
                    case .shape(let shape):
                        elementsToUpload[shape.id] = EditableElementData(element: .shape(EditableShapeData(from: shape)))
                        
                    case .sticker(let sticker):
                        elementsToUpload[sticker.id] = EditableElementData(element: .sticker(EditableStickerData(from: sticker)))
                        
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
                        
                    case .poll(let poll):
                        elementsToUpload[poll.id] = EditableElementData(element: .poll(EditablePollData(from: poll)))
                        
                    }
                }
                
                // Creating the thumbnail
                
                guard let conversionData = thumbnail(elementsArray: elementsArray) else {return}
                
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
                
//                elementToProfile(post: updatedPost)
                
                // Dismiss View
                dismiss()
                
            }
            
        })
    }
    
    
//    func elementToProfile(post: Post) {
//        
//        let userDocRef = Firestore.firestore().collection("Users").document(userUID)
//
//        userDocRef.getDocument { (document, error) in
//            if let error = error {
//                print("Error getting user document: \(error)")
//                return
//            }
//
//            guard let document = document, document.exists else {
//                print("User document does not exist.")
//                return
//            }
//
//            // Access the profile field from the document
//            if var profileDoc = document.data()?["profile"] as? [String: Any] {
//                // Access the elements field from the profile dictionary
//                var elementsArray = profileDoc["elements"] as? [[String: Any]] ?? []
//
//                // Create a new profileElement
//                let newProfileElement: [String: Any] = [
//                    "id": elementsArray.count, // Use the count of elements as the new ID
//                    "element": [
//                        "type": "image", // Change the type and properties based on your actual structure
//                        "data": ["thumbnail": try String(contentsOf: post.thumbnail)]
//                    ],
//                    "width": 4,
//                    "height": 2,
//                    "redirect": [
//                        "type": "post", // Change the type and properties based on your actual structure
//                        "data": ["id": post.id]
//                    ],
//                    "pinned": false
//                ]
//
//                // Add the new profileElement to the elements array
//                elementsArray.append(newProfileElement)
//
//                // Update the profile dictionary with the modified elements array
//                profileDoc["elements"] = elementsArray
//
//                // Update the user document with the modified profile dictionary
//                userDocRef.setData(["profile": profileDoc], merge: true) { error in
//                    if let error = error {
//                        print("Error updating user document: \(error)")
//                    } else {
//                        print("User document updated successfully.")
//                    }
//                }
//            }
//        }
        
//        Firestore.firestore().collection("Users").document(userUID).getDocument() { (document, error) in
//            if let document = document, document.exists {
//                    // Access the "profile" map
//                if let profile = document.data()?["profile"] as? [String: Any] {
//                        // Access the "elements" array
//                        if let elements = profile["elements"] as? [profileElement] {
//                            // Do something with the elements array
//                            let newElement = profileElement(
//                                id: elements.count,
//                                element: .image(profileImage(image: post.thumbnail)),
//                                width: 4,
//                                height: 2,
//                                redirect: .post(post.id ?? ""),
//                                pinned: false
//                            )
//                            
//                                profile.updateData([
//                                    "elements": FieldValue.arrayUnion([newElement])
//                                ]) { error in
//                                    if let error = error {
//                                        print("Error updating document: \(error)")
//                                    } else {
//                                        print("Document updated successfully")
//                                    }
//                                }
//                        }
//                    }
//                } else {
//                    print("Document does not exist")
//                }
        
//    }
    
//    func elementToProfile(post: Post) async {
//        
//        guard let userDocRef = await Firestore.firestore().collection("Users").document(userUID).getDocument() else {return}
//
//        userDocRef.getDocument { (document, error) in
//            if let error = error {
//                print("Error getting user document: \(error)")
//                return
//            }
//
//            guard let document = document, document.exists else {
//                print("User document does not exist.")
//                return
//            }
//
//            // Access the profile field from the document
//            if var profileDoc = document.data()?["profile"] as? [String: Any] {
//                // Access the elements field from the profile dictionary
//                var elementsArray = profileDoc["elements"] as? [[String: Any]] ?? []
//
//                // Create a new profileElement
//                let newProfileElement: [String: Any] = [
//                    "id": elementsArray.count, // Use the count of elements as the new ID
//                    "element": [
//                        "type": "image", // Change the type and properties based on your actual structure
//                        "data": ["thumbnail": post.thumbnail]
//                    ],
//                    "width": 4,
//                    "height": 2,
//                    "redirect": [
//                        "type": "post", // Change the type and properties based on your actual structure
//                        "data": ["id": post.id]
//                    ],
//                    "pinned": false
//                ]
//
//                // Add the new profileElement to the elements array
//                elementsArray.append(newProfileElement)
//
//                // Update the profile dictionary with the modified elements array
//                profileDoc["elements"] = elementsArray
//
//                // Update the user document with the modified profile dictionary
//                userDocRef.setData(["profile": profileDoc], merge: true) { error in
//                    if let error = error {
//                        print("Error updating user document: \(error)")
//                    } else {
//                        print("User document updated successfully.")
//                    }
//                }
//            }
//        }
//        
//    }
    
    func setError(_ error: Error )async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
        
    }
    
    @MainActor func snapshot(text: editableTxt) -> UIImage? {
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
    
    @MainActor func thumbnail(elementsArray: editorElementsArray) -> UIImage? {
        
        var peak = CGFloat.zero
        
        for (_, element) in elementsArray.elements {
            let element = element.element
            
            peak = max(peak, ((element.size.height * element.scalar) / 2) + abs(element.position.height))
        }
        
        let imagerenderer = ImageRenderer(
            
            content:
                
                ZStack {
                    
                    Color.white
                        .frame(width: UIScreen.main.bounds.width, height: peak * 2)
                    
                    ForEach(elementsArray.elements.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                        if let itemToDisplay = elementsArray.elements[key] {
                            EditableElement(element: itemToDisplay, elementsArray: elementsArray, sharedEditNotifier: SharedEditState())
                            
                        }
                        
                    }
                }
        )
        imagerenderer.scale = UIScreen.main.scale
        
        return imagerenderer.uiImage
    }
    
}

// idk how the fuck to do this

//guard let userDocRef = Firestore.firestore().collection("Users").document(userUID).getDocument() else {return}
//
//userDocRef.getDocument { (document, error) in
//    if let error = error {
//        print("Error getting user document: \(error)")
//        return
//    }
//
//    guard let document = document, document.exists else {
//        print("User document does not exist.")
//        return
//    }
//
//    // Access the profile field from the document
//    if var profileDoc = document.data()?["profile"] as? [String: Any] {
//        // Access the elements field from the profile dictionary
//        var elementsArray = profileDoc["elements"] as? [[String: Any]] ?? []
//
//        // Create a new profileElement
//        let newProfileElement: [String: Any] = [
//            "id": elementsArray.count, // Use the count of elements as the new ID
//            "element": [
//                "type": "image", // Change the type and properties based on your actual structure
//                "data": ["thumbnail": post.thumbnail]
//            ],
//            "width": 4,
//            "height": 2,
//            "redirect": [
//                "type": "post", // Change the type and properties based on your actual structure
//                "data": ["id": doc.documentID]
//            ],
//            "pinned": false
//        ]
//
//        // Add the new profileElement to the elements array
//        elementsArray.append(newProfileElement)
//
//        // Update the profile dictionary with the modified elements array
//        profileDoc["elements"] = elementsArray
//
//        // Update the user document with the modified profile dictionary
//        userDocRef.setData(["profile": profileDoc], merge: true) { error in
//            if let error = error {
//                print("Error updating user document: \(error)")
//            } else {
//                print("User document updated successfully.")
//            }
//        }
//    }
//}

struct CreateNewPost_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPost{_ in
            
        }
    }
}
