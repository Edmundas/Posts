//
//  PostsViewController.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-05.
//

import UIKit
import Combine

class PostsViewController: BaseViewController<PostsViewModel> {

    // MARK: - Private views
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("actionPullToRefresh", comment: ""))
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = refreshControl
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("titleEmpty", comment: "").uppercased()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40.0)
        label.textColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Private variables
    private lazy var dataSource = setupDataSource()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupViews()
        setupBindings()
    }

    // MARK: - Private methods
    private func setupNavigationBar() {
        let navigationBarApperance = UINavigationBarAppearance()
        navigationBarApperance.configureWithDefaultBackground()

        navigationController?.navigationBar.standardAppearance = navigationBarApperance
        navigationController?.navigationBar.compactAppearance = navigationBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarApperance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarApperance

        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.title = NSLocalizedString("titlePosts", comment: "")
    }
    
    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyLabel.topAnchor.constraint(equalTo: view.topAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.retryPublisher
            .merge(with: refreshControl.publisher(for: .valueChanged))
            .sink { [weak self] in
                self?.viewModel.onRefresh()
            }
            .store(in: &cancellables)

        viewModel.$posts
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] posts in
                self?.refreshControl.endRefreshing()
                self?.emptyLabel.isHidden = !posts.isEmpty

                var snapshot = NSDiffableDataSourceSnapshot<Int, PostViewModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(posts, toSection: 0)
                self?.dataSource.apply(snapshot)
            }
            .store(in: &cancellables)
    }
    
    private func setupDataSource() -> UITableViewDiffableDataSource<Int, PostViewModel> {
        UITableViewDiffableDataSource<Int, PostViewModel>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {
                fatalError(PostTableViewCell.identifier + " not found")
            }

            cell.setup(with: itemIdentifier)
            
            return cell
        }
    }

}
