//
//  ContentView.swift
//  product
//
//  Created by Gaurav Bhardwaj on 09/08/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    if !viewModel.selectedProducts.isEmpty {
                        NavigationLink(destination: CartView().environmentObject(viewModel)) {
                            Text("Add to Cart")

                        }
                    }
                }
                .padding([.top, .trailing])

                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.filteredProducts, id: \.id) { product in
                            ProductRowView(product: product)
                                .padding(.vertical, 5)
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddProductView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                viewModel.fetchProducts()
            }
            .refreshable {
                viewModel.fetchProducts()
            }
        }
    }
}



