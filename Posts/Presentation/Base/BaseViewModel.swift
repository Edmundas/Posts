//
//  BaseViewModel.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-05.
//

import Combine

class BaseViewModel {

    // MARK: - Public variables
    var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var errorPublisher = errorSubject.eraseToAnyPublisher()
    let errorSubject = PassthroughSubject<Error, Never>()

    private(set) lazy var retryPublisher = retrySubject.eraseToAnyPublisher()
    let retrySubject = PassthroughSubject<Void, Never>()

    // MARK: - Lifecycle
    deinit {
        debugPrint("deinit of ", String(describing: self))
    }

    // MARK: - Public methods
    func bind() {}
    
}
