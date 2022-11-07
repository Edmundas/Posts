//
//  UsersStorage.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation
import Combine
import CoreData

protocol UsersStorage {
    func fetchUsers() -> AnyPublisher<[UserEntity], Error>
    func saveUsers(_ users: [User])
}

class UsersStorageImpl: UsersStorage {

    // MARK: - Private variables
    private let managedContext: NSManagedObjectContext

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }

    // MARK: - Public methods
    func fetchUsers() -> AnyPublisher<[UserEntity], Error> {
        let resultSubject = PassthroughSubject<[UserEntity], Error>()

        let usersFetch = UserEntity.fetchRequest()
        let sortById = NSSortDescriptor(key: "id", ascending: true)
        usersFetch.sortDescriptors = [sortById]

        // TODO: different context on background thread ???
        DispatchQueue.global(qos: .background).async {
            do {
                let results = try self.managedContext.fetch(usersFetch)
                resultSubject.send(results)
            } catch {
                resultSubject.send(completion: .failure(error))
            }
        }

        return resultSubject.eraseToAnyPublisher()
    }

    func saveUsers(_ users: [User]) {
        // TODO: background thread ???
        users.forEach {
            do {
                let userFetch = UserEntity.fetchRequest()
                userFetch.predicate = NSPredicate(format: "id == %d", $0.id)
                userFetch.fetchLimit = 1

                let existingUsers = try self.managedContext.fetch(userFetch)

                var user: UserEntity
                if let existingUser = existingUsers.first {
                    user = existingUser
                } else {
                    user = UserEntity(context: self.managedContext)
                }

                user.id = Int64($0.id)
                user.name = $0.name

                // TODO: DELETE no longer in use
            } catch {
                #warning("TODO: [UsersStorage] UPDATE_USERS_ERROR")
                debugPrint(error)
            }
        }

        do {
            try self.managedContext.save()
        } catch {
            #warning("TODO: [UsersStorage] SAVE_USERS_ERROR")
            debugPrint(error)
        }
    }

}
