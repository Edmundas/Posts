//
//  PostsStorage.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation
import Combine
import CoreData

protocol PostsStorage {
    func fetchPosts() -> AnyPublisher<[PostEntity], Error>
    func savePosts(_ posts: [Post])
}

class PostsStorageImpl: PostsStorage {

    // MARK: - Private variables
    private let managedContext: NSManagedObjectContext

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }

    // MARK: - Public methods
    func fetchPosts() -> AnyPublisher<[PostEntity], Error> {
        let resultSubject = PassthroughSubject<[PostEntity], Error>()

        let postsFetch = PostEntity.fetchRequest()
        let sortById = NSSortDescriptor(key: "id", ascending: true)
        postsFetch.sortDescriptors = [sortById]

        // TODO: different context on background thread ???
        DispatchQueue.global(qos: .background).async {
            do {
                let results = try self.managedContext.fetch(postsFetch)
                resultSubject.send(results)
            } catch {
                resultSubject.send(completion: .failure(error))
            }
        }

        return resultSubject.eraseToAnyPublisher()
    }

    func savePosts(_ posts: [Post]) {
        // TODO: background thread ???
        posts.forEach {
            do {
                let postFetch = PostEntity.fetchRequest()
                postFetch.predicate = NSPredicate(format: "id == %d", $0.id)
                postFetch.fetchLimit = 1

                let existingPosts = try self.managedContext.fetch(postFetch)

                var post: PostEntity
                if let existingPost = existingPosts.first {
                    post = existingPost
                } else {
                    post = PostEntity(context: self.managedContext)
                }

                post.id = Int64($0.id)
                post.title = $0.title

                if let postUser = $0.user {
                    let userFetch = UserEntity.fetchRequest()
                    userFetch.predicate = NSPredicate(format: "id == %d", postUser.id)

                    let existingUsers = try self.managedContext.fetch(userFetch)

                    var user: UserEntity?
                    if let existingUser = existingUsers.first {
                        user = existingUser
                    } else {
//                        user = UserEntity(context: self.managedContext)
//                        user.id = Int64(postUser.id)
//                        user.name = postUser.name
                    }

                    post.user = user
                }

                // TODO: DELETE no longer in use
            } catch {
                #warning("TODO: [PostsStorage] UPDATE_POSTS_ERROR")
                debugPrint(error)
            }
        }

        do {
            try self.managedContext.save()
        } catch {
            #warning("TODO: [PostsStorage] SAVE_POSTS_ERROR")
            debugPrint(error)
        }
    }

}
