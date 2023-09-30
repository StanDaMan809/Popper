//
//  ContentView.swift
//  Popper
//
//  Created by Stanley Grullon on 9/29/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        // Redirecting User Based on Log Status
        if logStatus {
            MainView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
