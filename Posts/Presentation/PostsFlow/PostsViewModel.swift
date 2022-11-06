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

    // MARK: - Private variables
    private var postsRepository: PostsRepository

    // MARK: - Lifecycle
    init(postsRepository: PostsRepository) {
        self.postsRepository = postsRepository
        super.init()
    }

    // MARK: - Public methods
    override func bind() {
        fetchPosts()
    }

    func onRefresh() {
        fetchPosts()
    }

    // MARK: - Private methods
    private func fetchPosts() {
        postsRepository.fetchPosts()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorSubject.send(error)
                    #warning("_FETCH_POSTS_ERROR")
                    debugPrint(error)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] posts in
                self?.posts = posts.map { PostViewModel(id: $0.id, title: $0.title, user: $0.user?.name ?? "-") }
            }
            .store(in: &cancellables)
    }

}
