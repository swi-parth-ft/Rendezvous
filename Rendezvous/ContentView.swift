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
        VStack {
            MapReader { proxy in
                Map {
                    ForEach(locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Text(location.name)
                                .font(.headline)
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(.capsule)
                        }
                        .annotationTitles(.hidden)
                    }
                }
            }
            
            HStack(spacing: 50) {
                Button("Paris") {
                    position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        )
                    )
                }

                Button("Tokyo") {
                    position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        )
                    )
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
