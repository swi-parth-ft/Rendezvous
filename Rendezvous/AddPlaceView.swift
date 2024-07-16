//
//  AddPlaceView.swift
//  Rendezvous
//
//  Created by Parth Antala on 2024-07-16.
//

import SwiftUI

struct AddPlaceView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var description = ""
    
    var long: Double
    var lat: Double
    var onSave: (Location) -> Void
    
    
    var body: some View {
        Form {
            TextField("name", text: $name)
            TextField("Description", text: $description)
            
            Button("Save") {
                let newPlace = Location(id: UUID(), name: name, description: description, latitude: lat, longitude: long)
                onSave(newPlace)
                dismiss()
            }
        }
    }
    
    init(long: Double, lat: Double, onSave: @escaping (Location) -> Void) {
        
        
        self.onSave = onSave
        self.lat = lat
        self.long = long
        
//        _name = State(initialValue: location.name)
//        _description = State(initialValue: location.description)
        
        
    }
}

#Preview {
    AddPlaceView(long: 0, lat: 0) { _ in }
}
