//
//  PostsAPI.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation

public enum PostsAPI {
    case getPosts
}

extension PostsAPI: NetworkRequest {
    public var base: String { AppSettings.shared.baseURLString }

    public var path: String {
        switch self {
        case .getPosts:
            return "/posts"
        }
    }

    public var method: String { "GET" }
}
