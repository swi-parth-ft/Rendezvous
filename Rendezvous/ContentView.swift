//
//  ContentView.swift
//  Rendezvous
//
//  Created by Parth Antala on 2024-07-16.
//

import SwiftUI

struct ContentView: View {
   
    
    var body: some View {
        Button("Save") {
            let data = Data("Text Message".utf8)
            
            do {
                try FileManager.default.save(data, to: "message.txt")
                let loadedData = try FileManager.default.load("message.txt")
                
                print(String(data: loadedData, encoding: .utf8) ?? "")
                
            } catch {
                print(error.localizedDescription)
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
