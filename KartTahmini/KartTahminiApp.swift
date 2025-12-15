//
//  KartTahminiApp.swift
//  KartTahmini
//
//  Created by Sedanur Kırcı on 16.12.2025.
//

import SwiftUI
import Firebase

@main
struct KartTahminiApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
