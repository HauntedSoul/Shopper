//
//  CartProduct.swift
//  Shopper
//
//  Created by Vitor Dinis on 21/10/2022.
//

import Foundation

struct CartProduct: Codable {
    
    let id: Int
    var ammount: Int = 1
    
    // MARK: Preview helpers
    
    static func testProduct() -> CartProduct {
        CartProduct(id: .random(in: 0...999999), ammount: .random(in: 1...15))
    }
}
