//
//  MainView.swift
//  Popper
//
//  Created by Stanley Grullon on 9/30/23.
//

import SwiftUI

struct MainView: View {
    @State private var isEditorActive = false
    
    var body: some View {
        TabView{
            PostsView()
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Posts")
                }
            
            Button(action: {
                isEditorActive.toggle()
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .tabItem {
                Image(systemName: "plus")
            }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
        .tint(.black) // changes label tint to black
        .fullScreenCover(isPresented: $isEditorActive, content: {
            Editor()
        })
    }
}

//struct MainView: View {
//    @State private var isEditorActive = false
//    
//    var body: some View {
//        
//        if isEditorActive {
//            Editor()
//        } else
//        {
//            
//            
//            TabView{
//                
//                PostsView()
//                    .tabItem {
//                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
//                        Text("Posts")
//                    }
//                
//                // Needs to open up the drafts and create a post, I guess?
//                // If there are no drafts saved, it just goes straight to the editor. 
//                Editor() // this is a placeholder for now ...
//                    .tabItem {
//                        Image(systemName: "plus")
//                    }
//                
//                ProfileView()
//                    .tabItem {
//                        Image(systemName: "gear")
//                        Text("Profile")
//                    }
//            }
//            
//            .tint(.black) // changes label tint to black
//            
//        }
//        }
//}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
