//
//  PostsRepository.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation
import Combine

protocol PostsRepository {
    func fetchPosts() -> AnyPublisher<[Post], Error>
}

class PostsRepositoryImpl: PostsRepository {

    // MARK: - Private variables
    private let postsService: PostsService
    private let usersRepository: UsersRepository

    var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    init(postsService: PostsService, usersRepository: UsersRepository) {
        self.postsService = postsService
        self.usersRepository = usersRepository
    }

    // MARK: - Public methods
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        postsService.getPosts()
            .flatMap(testUsers)
            .eraseToAnyPublisher()
    }

    // MARK: - Private methods
    private func testUsers(_ posts: [PostDTO]) -> AnyPublisher<[Post], Error> {
        let ids = Array(Set(posts.map { $0.userId} ))
        let resultSubject = PassthroughSubject<[Post], Error>()

        usersRepository.fetchUsers(by: ids)
            .sink { completion in
                resultSubject.send(completion: completion)
            } receiveValue: { users in
                let results = posts.map { post in
                    Post(post, user: users.first(where: { $0.id == post.userId }))
                }
                resultSubject.send(results)
            }
            .store(in: &cancellables)

        return resultSubject.eraseToAnyPublisher()
    }

}
