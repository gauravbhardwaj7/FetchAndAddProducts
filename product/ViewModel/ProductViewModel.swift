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
    private let baseUrl = "https://app.getswipe.in/api/public"

    @Published var searchText: String = ""

    init() {
        fetchProducts()
    }

    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { product in
                product.productName.lowercased().contains(searchText.lowercased()) ||
                product.productType.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func fetchProducts() {
      let fetchUrl = "\(baseUrl)/get"
        guard let url = URL(string: fetchUrl) else {
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
      let addUrl = "\(baseUrl)/add"
        guard let url = URL(string: addUrl) else {
            self.errorMessage = "Invalid URL"
            return
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let uuid = UUID()

        let parameters = [
            "product_name": productName,
            "product_type": productType,
            "price": price,
            "tax": tax
        ]

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        for imageData in images {
            let filename = "image\(uuid).jpg"
            let mimetype = "image/jpeg"

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")

        request.httpBody = body


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

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}




