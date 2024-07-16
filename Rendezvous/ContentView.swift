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
    @State private var long: Double = 0
    @State private var lat: Double = 0
    
    var body: some View {
        if !viewModel.isUnlocked {
            NavigationStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        if viewModel.isShowingFav {
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
                                            
                                        }
                                }
                            }
                        }
                    }
                    .mapStyle(viewModel.mapMode == MapMode.hybrid ? .hybrid : .standard)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.isAddingplace = true
                            long = coordinate.longitude
                            lat = coordinate.latitude
                            print("Tapped at \(coordinate)")
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) { newLocation in
                            viewModel.updateLocation(location: newLocation)
                        }
                        
                    }
                    .sheet(isPresented: $viewModel.isAddingplace, content: {
                        AddPlaceView(long: long, lat: lat) { newLocation in
                            viewModel.addLocation(location: newLocation)
                        }
                        .presentationDetents([.fraction(0.4), .medium, .large])
                    })
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                withAnimation {
                                    if viewModel.mapMode == MapMode.hybrid {
                                        viewModel.mapMode = .normal
                                    } else {
                                        viewModel.mapMode = .hybrid
                                    }
                                }
                            } label: {
                                Image(systemName: viewModel.mapMode == .hybrid ? "map" : "globe")
                                    .shadow(radius: 5)
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                withAnimation {
                                    viewModel.isShowingFav.toggle()
                                }
                            } label: {
                                Image(systemName: viewModel.isShowingFav ? "star.fill" : "star")
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .toolbarBackground(Color.clear, for: .navigationBar)
                    .toolbarBackground(.hidden, for: .navigationBar)
                    
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
        var isShowingFav = false
        var mapMode = MapMode.normal
        var isAddingplace = false
        
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
        
        func addLocation(location: Location) {
            locations.append(location)
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


