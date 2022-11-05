//
//  BaseCoordinator.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-05.
//

import UIKit
import Combine

class BaseCoordinator {

    var childCoordinators: [BaseCoordinator] = []
    var cancellables = Set<AnyCancellable>()

    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()

    func start() {}
    
}

extension BaseCoordinator {

    func addChild(coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(coordinator: BaseCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

}
