//
//  ContentView.swift
//  Rendezvous
//
//  Created by Parth Antala on 2024-07-16.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    let locations = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    var body: some View {
        
        MapReader { proxy in
            Map()
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            print(coordinate)
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
