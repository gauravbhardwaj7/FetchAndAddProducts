//
//  ProductRowView.swift
//  product
//
//  Created by Gaurav Bhardwaj on 11/08/24.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product

    var body: some View {
        HStack {
            if let url = URL(string: product.image), !product.image.isEmpty {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
                    .overlay(Text("No Image"))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(product.productName)
                    .font(.headline)
                Text("Price: $\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                Text("Type: \(product.productType)")
                    .font(.subheadline)
                Text("Tax: \(product.tax, specifier: "%.2f")%")
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

