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
    
    init() {
        self.items = []
        loadCart()
    }
    
    init(items: [CartProduct]) {
        self.items = items
    }
    
    func cartContainsProduct(productId: Int) -> Bool {
        return items.contains(where: { $0.id == productId })
    }
    
    func addToCart(product: Product) {
        guard !items.contains(where: { $0.id == product.id }) else { return }
        items.append(CartProduct(id: product.id))
        storeCart()
    }
    
    func incrementCartProduct(productId: Int) {
        guard let index = items.firstIndex(where: { $0.id == productId }) else { return }
        //        if let stock = productList.first(where: { $0.id == productId })?.stock, items[index].ammount >= stock {
        //            items[index].ammount = stock
        //        } else {
        items[index].ammount += 1
        //        }
        storeCart()
    }
    
    func decrementCartProduct(productId: Int) {
        guard let index = items.firstIndex(where: { $0.id == productId }) else { return }
        if items[index].ammount <= 1 {
            items.remove(at: index)
        } else {
            items[index].ammount -= 1
        }
        storeCart()
    }
    
    
    // MARK: Storage
    
    /// Stores the list of products in local storage
    func storeCart() {
        do {
            let data = try PropertyListEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: LocalStorageKeys.cart)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    /// Loads the stored list of products from local storage
    func loadCart() {
        if let data = UserDefaults.standard.object(forKey: LocalStorageKeys.cart) as? Data {
            do {
                let items = try PropertyListDecoder().decode([CartProduct].self, from: data)
                self.items = items
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: Preview helpers
    
    static func testObject() -> Cart {
        let cart = Cart()
        cart.items = .init(repeating: .testProduct(), count: .random(in: 1...10))
        return cart
    }
}


struct LocalStorageKeys {
    static let cart = "cartStorage"
}
