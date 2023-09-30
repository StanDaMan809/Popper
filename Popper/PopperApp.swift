//
//  PopperApp.swift
//  Popper
//
//  Created by Stanley Grullon on 4/6/23.
//

import SwiftUI
import Firebase

@main

struct PopperApp: App {
    init() {
        FirebaseApp.configure() 
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            Feed()
        }
    }
}


