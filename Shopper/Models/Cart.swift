//
//  Cart.swift
//  Shopper
//
//  Created by Vitor Dinis on 21/10/2022.
//

import Foundation

class Cart: ObservableObject {
    
    @Published var items = [CartProduct]()
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var count: Int {
        items.count
    }
    
    func cartContainsProduct(productId: Int) -> Bool {
        return items.contains(where: { $0.id == productId })
    }
    
    func addToCart(product: Product) {
        guard !items.contains(where: { $0.id == product.id }) else { return }
        items.append(CartProduct(id: product.id))
    }
    
    func incrementCartProduct(productId: Int) {
        guard let index = items.firstIndex(where: { $0.id == productId }) else { return }
        //        if let stock = productList.first(where: { $0.id == productId })?.stock, items[index].ammount >= stock {
        //            items[index].ammount = stock
        //        } else {
        items[index].ammount += 1
        //        }
    }
    
    func decrementCartProduct(productId: Int) {
        guard let index = items.firstIndex(where: { $0.id == productId }) else { return }
        if items[index].ammount <= 1 {
            items.remove(at: index)
        } else {
            items[index].ammount -= 1
        }
    }
    
    // MARK: Storage
    
    /// Stores the list of products in local storage
    func storeCart() {
        UserDefaults.standard.set(items, forKey: LocalStorageKeys.cart)
    }
    
    /// Loads the stored list of products from local storage
    func loadCart() {
        if let items = UserDefaults.standard.object(forKey: LocalStorageKeys.cart) as? [CartProduct] {
            self.items = items
        }
    }
}


struct LocalStorageKeys {
    static let cart = "cartStorage"
}
