//
//  DetailsRepository.swift
//  izza
//
//  Created by Oleh on 08.09.2026.
//

protocol DetailsRepositoryProtocol {
    func fetchData() async throws -> [Pizza]
}
