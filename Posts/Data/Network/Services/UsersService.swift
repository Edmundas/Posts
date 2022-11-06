//
//  UsersService.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation
import Combine

protocol UsersService {
    func getUser(id: Int) -> AnyPublisher<UserDTO, Error>
}

class UsersServiceImpl: UsersService {

    // MARK: - Private variables
    private let networkProvider: NetworkProvider

    // MARK: - Lifecycle
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    // MARK: - Public methods
    func getUser(id: Int) -> AnyPublisher<UserDTO, Error> {
        networkProvider.request(UsersAPI.getUser(id: id), model: UserDTO.self)
    }

}
