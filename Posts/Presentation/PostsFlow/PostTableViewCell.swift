//
//  PostTableViewCell.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-05.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - Public variables
    static var identifier: String {
        String(describing: PostTableViewCell.self)
    }

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setup(with viewModel: PostViewModel) {
        var config = defaultContentConfiguration()
        config.text = viewModel.title
        config.secondaryText = viewModel.user
        contentConfiguration = config
    }

    // MARK: - Public methods
    private func setupViews() {
        selectionStyle = .none
    }

}
