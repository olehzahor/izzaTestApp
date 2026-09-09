//
//  SimpleLogger.swift
//  izza
//

import Foundation

final class SimpleLogger {
    func log(_ message: String) {
        print(message)
    }
}

extension SimpleLogger: NetworkLogger {
    func logNetworkRequest(_ message: String) {
        log(message)
    }

    func logNetworkResponse(_ message: String) {
        log(message)
    }

    func logNetworkError(_ message: String) {
        log(message)
    }
}
