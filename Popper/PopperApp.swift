//
//  PopperApp.swift
//  Popper
//
//  Created by Stanley Grullon on 4/6/23.
//

import SwiftUI
import Firebase
import GiphyUISDK

@main

struct PopperApp: App {
    
    init() {
        FirebaseApp.configure()
        Giphy.configure(apiKey: "I8wCsocavASK0L8dVxzO4UgZ1nPTzX06")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


