//
//  Model.swift
//  product
//
//  Created by Gaurav Bhardwaj on 09/08/24.
//

import Foundation


struct Product:Codable, Identifiable{
  let id = UUID()
  let image:String
  let price: Double
  let productName:String
  let productType: String
  let tax: Double

  enum CodingKeys: String, CodingKey{
    case image
    case price
    case productName = "product_name"
    case productType = "product_type"
    case tax
  }
}


struct AddProductResponse: Codable {
    let message: String
    let productDetails: Product
    let productId: Int
    let success: Bool
}
