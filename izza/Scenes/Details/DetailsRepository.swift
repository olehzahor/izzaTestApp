//
//  DetailsRepository.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

protocol DetailsRepositoryProtocol {
    var pizzas: [Pizza] { get }
    
    func fetchData() async throws
}

final class DetailsRepository: DetailsRepositoryProtocol {
    private let network: NetworkClient

    private(set) var pizzas: [Pizza] = []
    
    func fetchData() async throws {
        pizzas = try await network.request(OSA.Pizzas()).pizzas
    }
    
    init(network: NetworkClient) {
        self.network = network
    }
}
