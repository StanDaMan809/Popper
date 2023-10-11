//
//  RegisterView.swift
//  Popper
//
//  Created by Stanley Grullon on 9/30/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct RegisterView: View {
    
    @State var emailID: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    @State var isLoading: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var usernameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""

    var body: some View {
        VStack(spacing: 10)
        {
            Text("Register")
                .font(.largeTitle.bold())
                .hAlign(.center)
            
            Text("Welcome to Popper!")
                .font(.title3)
                .hAlign(.center)
            
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                
                HelperView()
            }
            
            
            HStack{
                Text("Already Have an Account?")
                    .foregroundColor(.gray)
                
                Button("Log In."){
                    dismiss()
                }
                .font(.callout)
                .fontWeight(.bold)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue {
                Task {
                    do {
                       guard let imageData = try await newValue.loadTransferable(type: Data.self) else { return }
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                    } catch {
                        
                    }
                }
            }
        }
        .alert(errorMessage, isPresented:$showError, actions: {})
    }
    
    @ViewBuilder
    func HelperView()->some View {
        // Email, Password, Forgot Password
        VStack(spacing: 12) {
            
            ZStack {
                if let userProfilePicData, let image = UIImage(data: userProfilePicData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .padding(.top, 25)
            .onTapGesture {
                showImagePicker.toggle()
                
            }
            
            TextField("Username", text: $username)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("About You", text: $userBio, axis: .vertical)
                .frame(minHeight:100, alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("Bio Link (Optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            
            
            Button(action: registerUser) {
                Text("Register")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.pink)
            }
            .disableWithOpacity(username == "" || userBio == "" || emailID == "" || password == "" || userProfilePicData == nil)
            .padding(.top, 10)
        }
    }
    
    func registerUser() {
        isLoading = true
        closeKeyboard()
        Task {
            do {
                // Create account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                // Uploading Profile Photo to Storage
                
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                
                guard let imageData = userProfilePicData else {return}
                
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                
                let _ = try await storageRef.putDataAsync(imageData)
                
                // Step 3: Downloading Photo URL
                
                let downloadURL = try await storageRef.downloadURL()
                
                // Step 4: Creating a User Firestore Object
                
                let user = User(username: username, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                
                // Step 5: Saving User Doc into Firestore Database
                
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: {
                    error in
                    if error == nil {
                        print("Saved Successfully")
                        usernameStored = username
                        self.userUID = userUID
                        profileURL = downloadURL
                        logStatus = true
                        
                    }
                })
                
            } catch {
                
                // Deleting Created Account In Case of Failure
                
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
