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
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )
    )
    
    @State private var locations = [Location]()
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                ForEach(locations) { location in
                        Marker(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    }
            }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                            locations.append(newLocation)
                        
                        print("Tapped at \(coordinate)")
                    }
                }
        }
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
