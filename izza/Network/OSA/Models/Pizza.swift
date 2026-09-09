//
//  Pizza.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import Foundation

struct PizzasResponse: Codable, Equatable, Sendable {
    let pizzas: [Pizza]
}

struct Pizza: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let description: String
    let imageURL: URL
    let variants: [PizzaVariant]
    let defaultSize: PizzaSize

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "image_url"
        case variants
        case defaultSize = "default_size"
    }
}

struct PizzaVariant: Codable, Equatable, Sendable {
    let size: PizzaSize
    let price: Double
}

enum PizzaSize: String, Codable, CaseIterable, Sendable {
    case small = "S"
    case medium = "M"
    case large = "L"
}
