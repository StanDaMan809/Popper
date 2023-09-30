//
//  MainView.swift
//  Popper
//
//  Created by Stanley Grullon on 9/30/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            Text("Posts")
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Posts")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
        .tint(.black) // changes label tint to black
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
