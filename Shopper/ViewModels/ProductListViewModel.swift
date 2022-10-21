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
    
    private let category: String
    
    init(category: String = "") {
        self.category = category
    }
    
    
    // MARK: View lifecycle
    
    func viewTitle() -> String {
        return category.isEmpty ? "Products" : category.categoryFormatted
    }
    
    func productListOnAppear() {
        if productList.isEmpty {
            loadProducts()
        }
    }
    
    func refreshProductList() {
        loadProducts()
    }
    
    
    // MARK: Data Loading
    
    /// Builds the string URL dependent on selected category
    private var dataURL: String {
        "https://dummyjson.com/products\(category.isEmpty ? "" : "/category/\(category)")"
    }
    
    private func loadProducts() {
        guard let url = URL(string: dataURL) else { return }
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

