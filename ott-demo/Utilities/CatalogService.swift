//
//  CatalogService.swift
//  ott-demo
//
//  Created by Davis Zarins on 22/08/2025.
//

import Foundation

enum CatalogError: Error, LocalizedError {
    case invalidURL
    case ioError(Error)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .ioError(let err):
            return "I/O error: \(err.localizedDescription)"
        case .decodingError(let err):
            return "Decoding failed: \(err.localizedDescription)"
        }
    }
}

protocol CatalogServiceProtocol {
    func fetchCatalog() async throws -> CatalogResponse
}

final class CatalogService: CatalogServiceProtocol {
    func fetchCatalog() async throws -> CatalogResponse {
        guard let url = Bundle.main.url(forResource: "catalog", withExtension: "json") else {
            throw CatalogError.invalidURL
        }
        
        let data: Data
        do {
            data = try await Task.detached(priority: .userInitiated) {
                try Data(contentsOf: url)
            }.value
        } catch {
            Logger.log(.error, "I/O error: \(error.localizedDescription)")
            throw CatalogError.ioError(error)
        }
        
        do {
            return try JSONDecoder().decode(CatalogResponse.self, from: data)
        } catch {
            Logger.log(.error, "Decoding error: \(error.localizedDescription)")
            throw CatalogError.decodingError(error)
        }
    }
}
