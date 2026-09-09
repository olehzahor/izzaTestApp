//
//  MockDetailsRepository.swift
//  izza
//
//  Created by Oleh on 09.09.2026.
//

import Foundation

final class MockDetailsRepository: DetailsRepositoryProtocol {
    var pizzas: [Pizza] = Pizza.mocks
    
    func fetchData() async throws {
        try await Task.sleep(for: .seconds(1))
        self.pizzas = Pizza.mocks
    }
}

private extension Pizza {
    static var mocks: [Pizza] = [
        Pizza(
            id: "midnight-harvest",
            name: "Midnight Harvest",
            description: "This pizza celebrates the rich and bold flavors of black olives paired with a medley of cheeses. The deep, earthy taste of black olives harmonizes beautifully with the creamy, melted cheeses.",
            imageURL: URL(string: "https://oursongapp.com/images/pizzas/pizza_midnight_harvest.png")!,
            variants: [
                PizzaVariant(size: .small, price: 14.99),
                PizzaVariant(size: .medium, price: 17.99),
                PizzaVariant(size: .large, price: 21.99)
            ],
            defaultSize: .medium
        ),
        Pizza(
            id: "pepperoni-blast",
            name: "Pepperoni Blast",
            description: "The combination of perfectly melted mozzarella cheese, tangy tomato sauce, and a crispy yet chewy crust creates a harmonious balance that leaves you wanting more.",
            imageURL: URL(string: "https://oursongapp.com/images/pizzas/pizza_pepperoni_blast.png")!,
            variants: [
                PizzaVariant(size: .small, price: 15.5),
                PizzaVariant(size: .medium, price: 17.99),
                PizzaVariant(size: .large, price: 22.5)
            ],
            defaultSize: .medium
        ),
        Pizza(
            id: "shrimptastic",
            name: "Shrimptastic",
            description: "This pizza showcases the perfect combination of shrimp and cheese, with gooey melted cheeses complementing the savory shrimp toppings for a truly indulgent experience.",
            imageURL: URL(string: "https://oursongapp.com/images/pizzas/pizza_shrimptastic.png")!,
            variants: [
                PizzaVariant(size: .small, price: 18.99),
                PizzaVariant(size: .medium, price: 21.99),
                PizzaVariant(size: .large, price: 25.99)
            ],
            defaultSize: .medium
        )
    ]
}
