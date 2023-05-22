//
//  Product.swift
//  SwiftInventory
//
//  Created by Alvaro  on 18/05/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Product: Identifiable, Codable {
    @DocumentID var id: String?
    
    var product: String
    var brand: String
    var amount: Int
    var price: Int
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case product
        case brand
        case amount 
        case price = "price"
        case image 
    }
}
