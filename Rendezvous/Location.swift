//
//  Location.swift
//  Rendezvous
//
//  Created by Parth Antala on 2024-07-16.
//

import Foundation

struct Location: Codable, Equatable, Identifiable {
    let id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
}
