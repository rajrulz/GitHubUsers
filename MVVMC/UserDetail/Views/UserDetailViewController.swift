//
//  UserDetailViewController.swift
//  MVVMC
//
//  Created by Rajneesh Biswal on 01/06/21.
//  Copyright © 2021 tawkto. All rights reserved.
//

import UIKit

protocol UserDetailViewControllerDelegate: class {
    func viewDidClose(sender: UserDetailViewController)
}
class UserDetailViewController: UIViewController {

    var model: Model {
        didSet {
            applyModel()
        }
    }
    private var loadingIndicator = UIActivityIndicatorView()
    private var tableView: UITableView?
    weak var delegate: UserDetailViewControllerDelegate?
    private var sections: [CellDisplayable] = []
    init(model: Model = .init()) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        applyModel()
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        tableView = UITableView()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.allowsMultipleSelection = false
        registerCells()
        tableView?.estimatedRowHeight = 180
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.separatorStyle = .none
        self.view = tableView
    }

    private func registerCells() {
        tableView?.register(UserDetailTableViewCell.self, forCellReuseIdentifier: UserDetailTableViewCell.id)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        delegate?.viewDidClose(sender: self)
    }

    private func applyModel() {
        if model.isEmpty() {
            showLoadingIndicator()
        } else {
            hideLoadingIndicator()
            sections.removeAll()
            sections.append(contentsOf: model.generateSections())
            title = model.screenTitle
            tableView?.reloadData()
        }
    }

    private func setUpView() {
        self.view.addAutoLayoutSubView(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    private func showLoadingIndicator() {
        tableView?.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        tableView?.isHidden = false
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }

}

extension UserDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailTableViewCell.id, for: indexPath) as? UserDetailTableViewCell else {
            fatalError("error while dequeuing cell")
        }
        cell.selectionStyle = .none
        cell.attach(cellView: sections[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
