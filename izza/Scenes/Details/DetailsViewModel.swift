//
//  DetailsViewModel.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

import SwiftUI

@Observable
final class DetailsViewModel {
    private let repo: DetailsRepositoryProtocol
    
    var selectedPizzaIndex: Int? = 0

    var pizzas: [Pizza] { repo.pizzas }
    
    var selectedPizza: Pizza {
        return pizzas[selectedPizzaIndex ?? 0]
    }
    
    var selectedSize: PizzaSize = .medium
    
    var pizzaImageURLs: [URL] {
        return pizzas.map { $0.imageURL }
    }
    
    var quantity = 1
    var price: Double {
        guard let variant = selectedPizza.variants.first(where: { $0.size == selectedSize }) else {
            return 0
        }

        return variant.price * Double(quantity)
    }
    
    var isFavorite = false
    
    init(repo: DetailsRepositoryProtocol) {
        self.repo = repo
    }
}
