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
    @State private var category = Cat.pin
    @State private var selectedCat = ""
    var long: Double
    var lat: Double
    var onSave: (Location) -> Void
    
    
    var body: some View {
        Form {
            TextField("name", text: $name)
            TextField("Description", text: $description)
            Picker("Category", selection: $category) {
                ForEach(Cat.allCases) { day in
                    if day == .food {
                        Text("Food")
                    } else {
                        Text(day.rawValue.capitalized).tag(day)
                    }
                }
            }
            Button("Save") {
                mapStrings(cat: category)
                let newPlace = Location(id: UUID(), name: name, description: description, latitude: lat, longitude: long, type: category)
                onSave(newPlace)
                dismiss()
            }
        }
    }
    
    func mapStrings(cat: Cat) {
        switch cat {
            
        case .star:
            selectedCat = "Star"
        case .home:
            selectedCat = "home"
        case .pin:
            selectedCat = "pin"
        case .food:
            selectedCat = "food"
        }
    }
    init(long: Double, lat: Double, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        self.lat = lat
        self.long = long
    }
}

#Preview {
    AddPlaceView(long: 0, lat: 0) { _ in }
}
