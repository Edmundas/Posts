//
//  AppCoordinator.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-05.
//

import UIKit
import Combine

final class AppCoordinator: BaseCoordinator {

    var window: UIWindow
    var navigationController: UINavigationController

    init(window: UIWindow, navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
        
        super.init()

        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
    }

    override func start() {
        postsFlow()
    }

    private func postsFlow() {
        let coordinator = PostsCoordinator(navigationController: navigationController)
        coordinator.didFinishPublisher
            .sink { [unowned self] in
                removeChild(coordinator: coordinator)
            }
            .store(in: &cancellables)
        coordinator.start()

        addChild(coordinator: coordinator)
    }

}
