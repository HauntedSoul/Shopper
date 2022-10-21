//
//  ProductListViewModel.swift
//  Shopper
//
//  Created by Vitor Dinis on 10/10/2022.
//

import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    
    @Published var productList: [Product] = []
    
    @Published var isLoading = false
    
    
    // MARK: View lifecycle
    
    func productListOnAppear() {
        if productList.isEmpty {
            loadProducts()
        }
    }
    
    func refreshProductList() {
        loadProducts()
    }
    
    
    //MARK: Product management
    
    func addToCart(product: Product) {
    }
    
    
    // Data Loading
    private func loadProducts() {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        isLoading = true
        
        var request = URLRequest(url: url, timeoutInterval: 3.0)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ProductListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.productList = decodedData.products ?? []
                    }
                } catch {
                    print("Error: JSON encoding failed")
                }
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }.resume()
    }
}



struct ProductListResponse: Codable {
    let products: [Product]?
    let total: Int?
    let skip: Int?
    let limit: Int?
}

