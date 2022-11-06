//
//  NetworkProvider.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation
import Combine

protocol NetworkProvider {
    func request<M: Decodable>(_ request: NetworkRequest, model: M.Type) -> AnyPublisher<M, Error>
}

class NetworkProviderImpl: NetworkProvider {

    // MARK: - Private variables
    private let urlSession: URLSession
    private lazy var jsonDecoder = JSONDecoder()

    // MARK: - Lifecycle
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    // MARK: - Public methods
    func request<M: Decodable>(_ request: NetworkRequest, model: M.Type) -> AnyPublisher<M, Error> {
        guard let requestURL = URL(string: request.base + request.path) else {
            fatalError("Invalid url: " + request.base + request.path)
        }

        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = request.method

        return urlSession.dataTaskPublisher(for: urlRequest)
            .mapError { NetworkError.unknown($0) }
            .map(\.data)
            .decode(type: M.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }

}
