//
//  PostDTO.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation

struct PostDTO: Decodable {
    let id: Int
    let title: String
    let userId: Int
}
