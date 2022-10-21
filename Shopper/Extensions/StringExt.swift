//
//  StringExt.swift
//  Shopper
//
//  Created by Vitor Dinis on 21/10/2022.
//

import Foundation

extension String {
    
    /// Returns the string formatted as designed for the title of a Category
    var categoryFormatted: String {
        let result = self.replacingOccurrences(of: "-", with: " ")
        return result.capitalized
    }
}
