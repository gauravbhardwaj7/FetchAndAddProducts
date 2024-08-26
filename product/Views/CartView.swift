//
//  CartView.swift
//  product
//
//  Created by Gaurav Bhardwaj on 26/08/24.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var viewModel: ProductViewModel

    var body: some View {
        NavigationView {
            List(viewModel.selectedProducts, id: \.id) { product in
                ProductRowView(product: product)
            }
            .navigationTitle("Cart")
        }
    }
}
