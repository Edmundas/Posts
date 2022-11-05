//
//  PostsViewModel.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-05.
//

import Combine

struct PostViewModel: Hashable {
    let id: Int
    let title: String
    let user: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

class PostsViewModel: BaseViewModel {

    // MARK: - Public variables
    @Published var posts: [PostViewModel]?

    // MARK: - Public methods
    override func bind() {
        #warning("_BIND")
        debugPrint("_BIND")
    }

    func onRefresh() {
        #warning("_ON_REFRESH")
        debugPrint("_ON_REFRESH")
    }

}
