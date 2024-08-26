//
//  ProductRowView.swift
//  product
//
//  Created by Gaurav Bhardwaj on 11/08/24.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: ProductViewModel
    @State private var isInCart: Bool = false

    var body: some View {
        HStack(spacing: 20) {
            if let url = URL(string: product.image), !product.image.isEmpty {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                } placeholder: {
                    Rectangle()
                        .fill(colorScheme == .dark ? Color.black : Color.white)
                        .frame(width: 100, height: 100)
                        .overlay(ProgressView())
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(product.productName)
                    .font(.headline)

                Text(product.productType)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack {
                    Text(formatPrice(product.price))
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text("+")
                    Text(String(format: "%.2f%%", product.tax))
                        .font(.subheadline)
                }
            }

            Spacer()

            Button(action: {
                isInCart.toggle()
                if isInCart {
                    viewModel.addProductToCart(product)
                } else {
                    viewModel.removeProductFromCart(product)
                }
            }) {
                Image(systemName: isInCart ? "minus.circle" : "cart.fill")
                    .foregroundColor(isInCart ? .red : .green)
            }
            .onAppear {
                isInCart = viewModel.isProductInCart(product)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
    }
}
