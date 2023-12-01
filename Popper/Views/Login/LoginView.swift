//
//  LoginView.swift
//  Popper
//
//  Created by Stanley Grullon on 9/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    // user details
    
    @State var emailID: String = ""
    @State var password: String = ""
    
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        
        VStack(spacing: 10)
        {
            Text("Sign In")
                .font(.largeTitle.bold())
                .hAlign(.center)
            
            Text("Welcome Back!")
                .font(.title3)
                .hAlign(.center)
            
            
            // Email, Password, Forgot Password
            VStack(spacing: 12) {
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top, 25)
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                Button("Forgot password?", action: resetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .hAlign(.trailing)
                
                Button(action: loginUser){
                    
                    Text("Log In")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.pink)
                }
                .padding(.top, 10)
            }
            
            HStack{
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Sign Up."){
                    createAccount.toggle()
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
        
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        // Display alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func loginUser() {
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User found")
                try await fetchUser()
            } catch {
                await setError(error)
            }
        }
    }
    
    func fetchUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else{return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        
        await MainActor.run(body: {
            // Setting UserDefaults data and Changhing App's Auth Status
            userUID = user.userUID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        })
    }
    
    func resetPassword() {
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("User found")
            } catch {
                await setError(error)
            }
        }
    }
    
    
    // Display Errors via alert
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

// Register View




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}





