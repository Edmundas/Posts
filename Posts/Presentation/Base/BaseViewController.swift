//
//  BaseViewController.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-05.
//

import UIKit
import Combine

class BaseViewController<VM: BaseViewModel>: UIViewController {

    // MARK: - Public variables
    var viewModel: VM
    var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    init(viewModel: VM) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        self.viewModel.bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    deinit {
        debugPrint("deinit of ", String(describing: self))
    }

    // MARK: - Private methods
    private func setupBindings() {
        viewModel.errorPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                let alertController = UIAlertController(title: NSLocalizedString("titleError", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                let retryAction = UIAlertAction(title: NSLocalizedString("actionRetry", comment: ""), style: .default) { [weak self] _ in
                    self?.viewModel.retrySubject.send()
                }
                let cancelAction = UIAlertAction(title: NSLocalizedString("actionCancel", comment: ""), style: .cancel, handler: nil)
                alertController.addAction(retryAction)
                alertController.addAction(cancelAction)
                self?.present(alertController, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }
}
