//
//  CategoryListViewModel.swift
//  Shopper
//
//  Created by Vitor Dinis on 21/10/2022.
//

import Foundation

class CategoryListViewModel: ObservableObject {
    
    @Published var categoryList: [String] = []
    
//    @Published var cart: Cart = Cart()
    
    @Published var isLoading = false
    
    
    // MARK: UI Lifecycle
    
    func categoryListOnAppear() {
        if categoryList.isEmpty {
            loadCategories()
        }
    }
    
    func refreshCategoryList() {
        loadCategories()
    }
    
    // MARK: Data loading
    
    /// Loads the list of categories from a set external API
    /// and loads the list of category names refreshing the observing view.
    private func loadCategories() {
        guard let url = URL(string: "https://dummyjson.com/products/categories") else { return }
        isLoading = true
        
        var request = URLRequest(url: url, timeoutInterval: 3.0)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if let data = data {
                do {
                    let decodedData = try JSONSerialization.jsonObject(with: data) as? [String]
                    DispatchQueue.main.async {
                        self.categoryList = decodedData ?? []
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
