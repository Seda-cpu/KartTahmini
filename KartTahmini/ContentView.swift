//
//  ContentView.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isReady = false
    
    var body: some View {
        Group {
            if isReady {
                NavigationStack {
                    HomeView()
                }
            } else {
                ProgressView("Connecting...")
            }
        }
        .onAppear {
            FirebaseService.shared.signInAnonymously { uid in
                isReady = (uid != nil)
            }
        }
    }
}

#Preview {
    ContentView()
}
