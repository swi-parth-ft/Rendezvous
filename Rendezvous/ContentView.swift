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
    
    
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )
    )
    
    @State private var viewModel = ViewModel()
    @State private var showSheet = false
    
    
    
    
   
    
    var body: some View {
        if viewModel.isUnlocked {
            NavigationStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onTapGesture {
                                        viewModel.selectedPlace = location
                                        showSheet = true
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.mapMode == MapMode.hybrid ? .hybrid : .standard)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            
                            viewModel.saveLocation(at: coordinate)
                            print("Tapped at \(coordinate)")
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) { newLocation in
                            viewModel.updateLocation(location: newLocation)
                        }
                        
                    }
                    .toolbar {
                        Button(viewModel.mapMode == MapMode.hybrid ? "Standard" : "Hybrid") {
                            if viewModel.mapMode == MapMode.hybrid {
                                viewModel.mapMode = .normal
                            } else {
                                viewModel.mapMode = .hybrid
                            }
                        }
                    }
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
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

enum MapMode {
    case normal
    case hybrid
}

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations = [Location]()
        var selectedPlace: Location?
        var isUnlocked = false
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        var mapMode = MapMode.normal
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("unable to save data.")
            }
        }
        
        func saveLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
     
        }
        
        
        func updateLocation(location: Location) {
            guard let selectedPlace else { return }
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "We need to unlock your data."
                
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        
                    }
                }
            }
        }
    }
    
    
}
#Preview {
    ContentView()
}


