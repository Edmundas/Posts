//
//  User.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String

    init(_ user: UserDTO) {
        self.id = user.id
        self.name = user.name
    }

    init(_ user: UserEntity) {
        self.id = Int(user.id)
        self.name = user.name
    }
    
}
