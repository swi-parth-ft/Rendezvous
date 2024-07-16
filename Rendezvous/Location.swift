//
//  Location.swift
//  Rendezvous
//
//  Created by Parth Antala on 2024-07-16.
//

import Foundation
import MapKit

enum Cat: String, Codable, CaseIterable, Identifiable {
    case star = "star"
    case home = "house"
    case pin = "pin"
    case food = "fork.knife"
    var id: Self { self }
}

struct Location: Codable, Equatable, Identifiable {
    
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var type: Cat
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    #if DEBUG
    static let example = Location(id: UUID(), name: "Bukinghum palace", description: "Lit by over 40,000 lightbulbs", latitude: 51.501, longitude: -0.141, type: Cat.pin)
    #endif
}
