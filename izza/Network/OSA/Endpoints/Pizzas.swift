//
//  Pizzas.swift
//  izza
//
//  Created by Oleh on 09.09.2026.
//

extension OSA {
    struct Pizzas: OSAEndpoint {
        typealias Response = PizzasResponse
        
        var path: String { "pizzas" }
        
        var method: HTTPMethod { .get }
    }
}
