//
//  AddProductView.swift
//  product
//
//  Created by Gaurav Bhardwaj on 11/08/24.
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

    var body: some View {
        Form {
            Section(header: Text("Product Details")) {
                TextField("Name", text: $productName)
                TextField("Type", text: $productType)
                TextField("Price(INR)", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Tax(%)", text: $tax)
                    .keyboardType(.decimalPad)
            }

            Section(header: Text("Image")) {
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
                    .onChange(of: selectedImageItem) { 
                        if let newItem = selectedImageItem {
                            loadImage(from: newItem) { data in
                                if let data = data {
                                    selectedImageData = data
                                }
                            }
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
            .navigationTitle("Add Product")
        }
    }
}

