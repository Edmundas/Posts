//
//  PostsCoordinator.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-05.
//

import UIKit
import Combine

final class PostsCoordinator: BaseCoordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        super.init()
    }

    override func start() {
        showMain()
    }

    private func showMain() {
        let viewModel = PostsViewModel()
        let viewController = PostsViewController(viewModel: viewModel)

        navigationController.setViewControllers([viewController], animated: false)
    }

}
