//
//  ContentView.swift
//  Rendezvous
//
//  Created by Parth Antala on 2024-07-16.
//

import SwiftUI
import MapKit
import LocalAuthentication


struct ContentView: View {
    
    @State private var isUnlocked = false
    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    
                }
            }
        }
    }
}

extension FileManager {
    
    
    func save(_ data: Data, to fileName: String) throws {
        let url = URL.documentsDirectory.appending(path: fileName)
        try data.write(to: url, options: [.atomic, .completeFileProtection])
    }
    
    func load(_ fileName: String) throws -> Data {
        let url = URL.documentsDirectory.appending(path: fileName)
        return try Data(contentsOf: url)
    }
}
#Preview {
    ContentView()
}
