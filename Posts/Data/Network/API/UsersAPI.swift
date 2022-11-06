//
//  UsersAPI.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation

public enum UsersAPI {
    case getUser(id: Int)
}

extension UsersAPI: NetworkRequest {
    public var base: String { AppSettings.shared.baseURLString }

    public var path: String {
        switch self {
        case .getUser(let id):
            return "/users/\(id)"
        }
    }

    public var method: String { "GET" }
}
