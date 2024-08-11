//
//  ContentView.swift
//  product
//
//  Created by Gaurav Bhardwaj on 09/08/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var isShowingAddProductView = false
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List(viewModel.products) { product in
                ProductRowView(product: product)
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddProductView = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isShowingAddProductView) {
                        AddProductView()
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }
}

