//
//  NetworkRequest.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//

import Foundation

protocol NetworkRequest {
    var base: String { get }
    var path: String { get }
    var method: String { get }
}
