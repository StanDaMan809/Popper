//
//  UserSettings.swift
//  Popper
//
//  Created by Stanley Grullon on 1/1/24.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct ProfileSettings: View {
    
    let user: User
    @AppStorage("log_status") var logStatus: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                VStack(alignment: .leading) {
                    
                    HStack {
                        
                        Spacer()
                        
                        WebImage(url: user.userProfileURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text("About You")
                        .font(.title2)
                        .padding(.vertical, 10)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("Nickname")
                            
                        
                        Spacer()
                        
                        Text(user.nickname)
                            .foregroundStyle(Color.gray)
                        
                        Image(systemName: "chevron.forward")
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("Username")
                            
                        
                        Spacer()
                        
                        Text(user.username)
                            .foregroundStyle(Color.gray)
                        
                        Image(systemName: "chevron.forward")
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("Bio")
                            
                        
                        Spacer()
                        
                        Text(user.userBio)
                            .foregroundStyle(Color.gray)
                            .frame(maxWidth: 200)
                            .lineLimit(3)
                        
                        Image(systemName: "chevron.forward")
                    }
                    .padding(.bottom, 10)
                    
                    Divider()
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("Visibility")
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            
                            Spacer()
                            
                            Text(user.publicProfile ? "Public" : "Private")
                                .foregroundStyle(Color.gray)
                            
                            Image(systemName: "chevron.forward")
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Divider()
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("Blocked")
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Divider()
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("Terms of Service")
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Divider()
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("Delete Account")
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Divider()
                    
                    Button {
                        logOutUser()
                    } label: {
                        Text("Log Out")
                            .foregroundStyle(Color.red)
                    }
                    .padding(.vertical, 5)
                    
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .navigationTitle("Profile")
        .padding()
    }
    
    func logOutUser() {
        try? Auth.auth().signOut()
        logStatus = false
    }
}


//struct UserSettings: View {
//    
//    
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//              
//                NavigationLink {
//                    
//                } label: {
//                    
//                    // Account Info
//                    // Private Account
//                    // Delete Account
//                    
//                    VStack(alignment: .leading ){
//                        Text("Profile Settings")
//                            .padding(.horizontal)
//                        
//                        Divider()
//                    }
//                    
//                }
//                .padding(.vertical, 5)
//                    
//                
//                NavigationLink {
//                    
//                } label: {
//                    VStack(alignment: .leading) {
//                        Text("Security")
//                            .padding(.horizontal)
//                        
//                        // Block
//                        // Block hashtags, phrases
//                        
//                        Divider()
//                    }
//                }
//                .padding(.vertical, 5)
//                
//                // Block
//                
//                NavigationLink { 
//                    
//                } label: {
//                    VStack(alignment: .leading) {
//                        Text("Terms of Service")
//                            .padding(.horizontal)
//                        
//                        Divider()
//                    }
//                }
//                .padding(.vertical, 5)
//                
//                
//                
//                Button {
//                    logOutUser()
//                } label: {
//                    VStack(alignment: .leading) {
//                        Text("Log Out")
//                            .foregroundStyle(Color.red)
//                            .padding(.horizontal)
//                        
//                        Divider()
//                        
//                    }
//                }
//                .padding(.vertical, 5)
//                
//                Spacer()
//                
//                
//            }
//        }
//        .navigationTitle("Settings")
//    }
//    
//    // Logging User Out
//    
//
//}

