//
//  PostsService.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation
import Combine

protocol PostsService {
    func getPosts() -> AnyPublisher<[PostDTO], Error>
}

class PostsServiceImpl: PostsService {

    // MARK: - Private variables
    private let networkProvider: NetworkProvider

    // MARK: - Lifecycle
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    // MARK: - Public methods
    func getPosts() -> AnyPublisher<[PostDTO], Error> {
        networkProvider.request(PostsAPI.getPosts, model: [PostDTO].self)
    }

}
