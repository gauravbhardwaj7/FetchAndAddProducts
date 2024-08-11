//
//  ProductViewModel.swift
//  product
//
//  Created by Gaurav Bhardwaj on 09/08/24.
//

import Combine
import Foundation

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: String? = nil
    private var cancellables = Set<AnyCancellable>()

    private let apiUrl = "https://app.getswipe.in/api/public/get"
    private let addProductUrl = "https://app.getswipe.in/api/public/add"

    init() {
        fetchProducts()
    }

    func fetchProducts() {
        guard let url = URL(string: apiUrl) else {
            self.errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Product].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to load products: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancellables)
    }

    func addProduct(productName: String, productType: String, price: String, tax: String, images: [Data] = []) {
        guard let url = URL(string: addProductUrl) else {
            self.errorMessage = "Invalid URL"
            return
        }

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "product_name", value: productName),
            URLQueryItem(name: "product_type", value: productType),
            URLQueryItem(name: "price", value: price),
            URLQueryItem(name: "tax", value: tax)
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.percentEncodedQuery?.data(using: .utf8)


        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: AddProductResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to add product: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                if response.success {
                    self?.products.append(response.productDetails)
                    self?.errorMessage = nil
                } else {
                    self?.errorMessage = response.message
                }
            })
            .store(in: &cancellables)
    }
}




