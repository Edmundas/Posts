//
//  UsersRepository.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation
import Combine
import CoreData

protocol UsersRepository {
    func fetchUsers() -> AnyPublisher<[User], Error>
    func syncUsers(by ids: [Int]) -> AnyPublisher<[User], Error>
}

class UsersRepositoryImpl: UsersRepository {

    // MARK: - Private variables
    private let usersService: UsersService
    private let usersStorage: UsersStorage

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    init(usersService: UsersService, usersStorage: UsersStorage) {
        self.usersService = usersService
        self.usersStorage = usersStorage
    }

    // MARK: - Public methods
    func fetchUsers() -> AnyPublisher<[User], Error> {
        usersStorage.fetchUsers()
            .map { users in
                users.map { User($0) }
            }
            .eraseToAnyPublisher()
    }

    func syncUsers(by ids: [Int]) -> AnyPublisher<[User], Error> {
        let resultSubject = PassthroughSubject<[User], Error>()

        ids.publisher
            .flatMap(syncUser)
            .collect()
            .sink { completion in
                resultSubject.send(completion: completion)
            } receiveValue: { [weak self] users in
                self?.usersStorage.saveUsers(users)
                resultSubject.send(users)
            }
            .store(in: &cancellables)


        return resultSubject.eraseToAnyPublisher()
    }

    // MARK: - Private methods
    private func syncUser(id: Int) -> AnyPublisher<User, Error> {
        usersService.getUser(id: id)
            .map { User($0) }
            .eraseToAnyPublisher()
    }

}
