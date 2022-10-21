//
//  Product.swift
//  Shopper
//
//  Created by Vitor Dinis on 10/10/2022.
//

import Foundation

/*
 {
 "id": 1,
 "title": "iPhone 9",
 "description": "An apple mobile which is nothing like apple",
 "price": 549,
 "discountPercentage": 12.96,
 "rating": 4.69,
 "stock": 94,
 "brand": "Apple",
 "category": "smartphones",
 "thumbnail": "...",
 "images": ["...", "...", "..."]
 }
 */

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
}
