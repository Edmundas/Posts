//
//  Post.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let title: String
    let user: User?

    init(_ post: PostDTO, user: User?) {
        self.id = post.id
        self.title = post.title
        self.user = user
    }

    init(_ post: PostEntity) {
        self.id = Int(post.id)
        self.title = post.title
        if let user = post.user {
            self.user = User(user)
        } else {
            self.user = nil
        }
    }

}
