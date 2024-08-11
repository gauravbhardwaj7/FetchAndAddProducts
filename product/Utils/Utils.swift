//
//  Utils.swift
//  product
//
//  Created by Gaurav Bhardwaj on 11/08/24.
//

import SwiftUI
import PhotosUI

func loadImage(from item: PhotosPickerItem, completion: @escaping (Data?) -> Void) {
    item.loadTransferable(type: Data.self) { result in
        switch result {
        case .success(let data):
            completion(data)
        case .failure(let error):
            print("Error loading image: \(error.localizedDescription)")
            completion(nil)
        }
    }
}

func formatPrice(_ price: Double) -> String {
       let formatter = NumberFormatter()
       formatter.numberStyle = .currency
       formatter.currencySymbol = "₹"
       formatter.maximumFractionDigits = 2
       formatter.locale = Locale(identifier: "en_IN")
       return formatter.string(from: NSNumber(value: price)) ?? "₹\(price)"
   }
