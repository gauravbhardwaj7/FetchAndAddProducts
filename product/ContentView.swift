//
//  ContentView.swift
//  product
//
//  Created by Gaurav Bhardwaj on 09/08/24.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ProductViewModel()

    @State private var productName: String = ""
    @State private var productType: String = ""
    @State private var price: String = ""
    @State private var tax: String = ""
    @State private var images: [Data] = []
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isPickerPresented: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Product Name", text: $productName)
                    TextField("Product Type", text: $productType)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Tax", text: $tax)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Images")) {
                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    PhotosPicker(
                        selection: $selectedImageItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select Image")
                        }
                        .onChange(of: selectedImageItem) { newItem in
                            if let newItem = newItem {
                                loadImage(from: newItem)
                            }
                        }
                }

                Button(action: {
                    if let selectedImageData {
                        images.append(selectedImageData)
                    }
                    viewModel.addProduct(productName: productName, productType: productType, price: price, tax: tax, images: images)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Product")
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add New Product")
        }
    }

    private func loadImage(from item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    DispatchQueue.main.async {
                        self.selectedImageData = data
                    }
                }
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
}

struct ProductListView: View {
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
