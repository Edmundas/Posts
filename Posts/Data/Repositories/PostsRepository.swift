//
//  PostsRepository.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation
import Combine
import CoreData

protocol PostsRepository {
    func fetchPosts() -> AnyPublisher<[Post], Error>
    func syncPosts() -> AnyPublisher<[Post], Error>
}

class PostsRepositoryImpl: PostsRepository {

    // MARK: - Private variables
    private let postsService: PostsService
    private let postsStorage: PostsStorage
    private let usersRepository: UsersRepository

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    init(postsService: PostsService, postsStorage: PostsStorage, usersRepository: UsersRepository) {
        self.postsService = postsService
        self.postsStorage = postsStorage
        self.usersRepository = usersRepository
    }

    // MARK: - Public methods
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        postsStorage.fetchPosts()
            .map { entities in
                entities.map { Post($0) }
            }
            .eraseToAnyPublisher()
    }

    func syncPosts() -> AnyPublisher<[Post], Error> {
        let resultSubject = PassthroughSubject<[Post], Error>()

        postsService.getPosts()
            .flatMap(syncUsers)
            .sink { completion in
                resultSubject.send(completion: completion)
            } receiveValue: { [weak self] posts in
                self?.postsStorage.savePosts(posts)
                resultSubject.send(posts)
            }
            .store(in: &cancellables)

        return resultSubject.eraseToAnyPublisher()
    }

    // MARK: - Private methods
    private func syncUsers(_ posts: [PostDTO]) -> AnyPublisher<[Post], Error> {
        let ids = Array(Set(posts.map { $0.userId} ))
        let resultSubject = PassthroughSubject<[Post], Error>()

        usersRepository.syncUsers(by: ids)
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
