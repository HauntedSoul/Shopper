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
    
    private var cancellableBag: [AnyCancellable] = []
    
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
    
    private func loadProducts() {
        isLoading = true
        Product.loadProductList()
            .sink { result in
                switch result {
                case .failure(let resultError):
                    print("ERROR: \(resultError.localizedDescription)")
                case .finished:
                    break
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } receiveValue: { productList in
                DispatchQueue.main.async {
                    self.productList = productList
                }
            }
            .store(in: &cancellableBag)

    }
}


