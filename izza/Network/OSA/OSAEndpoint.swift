//
//  OSAEndpoint.swift
//  izza
//
//  Created by Oleh on 09.09.2026.
//


import Foundation

protocol OSAEndpoint: Endpoint {}

extension OSAEndpoint {
    var baseURL: String {
        "https://oursongapp.com/api/"
    }

    var interceptors: [NetworkInterceptor] {
        OSAInfrastructure.interceptors
    }

    var decoder: DataDecoder {
        OSAInfrastructure.decoder
    }
}

private struct OSAInfrastructure {
    static let interceptors: [NetworkInterceptor] = [
        LoggingInterceptor(logger: SimpleLogger(), level: .compact)
    ]

    static let decoder: DataDecoder = JSONDecoder()
}
