//
//  Product.swift
//  Shopper
//
//  Created by Vitor Dinis on 10/10/2022.
//

import Foundation
import Combine


struct Product: Codable, Hashable {
    
    let id: Int
    let title: String
    let description: String
    let price: Int
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
    
    
    // MARK: API Calls
    
    static func loadProductList(category: String = "") -> Future<[Product], ProductAPIError> {
        return Future<[Product], ProductAPIError> { promise in
            let dataURL: String = "https://dummyjson.com/products\(category.isEmpty ? "" : "/category/\(category)")"
            
            guard let url = URL(string: dataURL) else {
                promise(.failure(.badURL))
                return
            }
            
            var request = URLRequest(url: url, timeoutInterval: 3.0)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    promise(.failure(.fetchError(error: error.localizedDescription)))
                }
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(ProductListResponse.self, from: data)
                        promise(.success(decodedData.products ?? []))
                    } catch {
                        promise(.failure(.decodeJSONError))
                    }
                }
            }.resume()
        }
    }
    
    enum ProductAPIError: Error {
        case badURL
        case fetchError(error: String)
        case decodeJSONError
    }
    
    struct ProductListResponse: Codable {
        let products: [Product]?
        let total: Int?
        let skip: Int?
        let limit: Int?
    }
}
