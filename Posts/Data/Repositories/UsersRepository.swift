//
//  UsersRepository.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation
import Combine

protocol UsersRepository {
    func fetchUser(id: Int) -> AnyPublisher<User, Error>
    func fetchUsers(by ids: [Int]) -> AnyPublisher<[User], Error>
}

class UsersRepositoryImpl: UsersRepository {

    // MARK: - Private variables
    private let usersService: UsersService

    // MARK: - Lifecycle
    init(usersService: UsersService) {
        self.usersService = usersService
    }

    // MARK: - Public methods
    func fetchUser(id: Int) -> AnyPublisher<User, Error> {
        usersService.getUser(id: id)
            .map { User($0) }
            .eraseToAnyPublisher()
    }

    func fetchUsers(by ids: [Int]) -> AnyPublisher<[User], Error> {
        ids.publisher
            .flatMap(fetchUser)
            .collect()
            .eraseToAnyPublisher()
    }

}
