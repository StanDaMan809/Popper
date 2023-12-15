//
//  ProfileView.swift
//  Popper
//
//  Created by Stanley Grullon on 9/30/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ProfileView: View {
    
    // Profile Data
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            if let myProfile {
                ReusableProfileContent(user: myProfile)
                    .refreshable {
                        self.myProfile = nil
                        await fetchUserData()
                    }
                
            } else {
                ProgressView()
            }
        }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        // Two actions
                        // 1. Log out
                        // 2. Delete Account
                        Button("Logout", action: logOutUser)
                        
                        Button("Delete Account", role: .destructive, action: deleteAccount)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
            .overlay {
                LoadingView(show: $isLoading)
            }
            .alert(errorMessage, isPresented: $showError) {
                
            }
            .task {
                // Modifier like onAppear -> fetches for the first time only
                if myProfile != nil {return}
                
                // initial fetch
                await fetchUserData()
            }
        }
    
    func fetchUserData()async {
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else{return}
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    
    // Logging User Out
    
    func logOutUser() {
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    // Deleting User Account
    
    func deleteAccount() {
        isLoading = true
        Task {
            do {
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                
                // Step 1: Deleting Profile Image from Storage
                
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                
                // Step 2: Deleting Firestore User Document
                
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                
                // Delete Auth Account and Setting Log Status to False
                
                try await Auth.auth().currentUser?.delete()
                
                logStatus = false
                
            } catch {
                await setError(error)
            }
            
        }
    }
    
    func setError(_ error: Error)async {
        // UI Must be run on main thread
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(profileEdit:)
//    }
//}
