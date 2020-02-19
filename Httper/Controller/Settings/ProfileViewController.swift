//
//  ProfileViewController.swift
//  Httper
//
//  Created by Meng Li on 2020/2/4.
//  Copyright © 2020 MuShare. All rights reserved.
//

private struct Const {
    struct header {
        static let height: CGFloat = 20
    }
    
    struct footer {
        static let height: CGFloat = 70
    }
    
    struct logout {
        static let height = 50
    }
}

class ProfileViewController: BaseViewController<ProfileViewModel> {
    
    private lazy var headerView = UIView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: Const.header.height)
        )
    )

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .navigation
        button.rx.tap.bind { [unowned self] in
            self.viewModel.logout(sourceView: button)
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: UIScreen.main.bounds.width, height: Const.footer.height)
            )
        )
        view.addSubview(logoutButton)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .darkGray
        tableView.rowHeight = 55
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.register(cellType: SelectionTableViewCell.self)
        tableView.rx.itemSelected.bind { [unowned self] in
            self.viewModel.pick(at: $0.row)
        }.disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var dataSource = SelectionTableViewCell.tableViewSingleSectionDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        view.addSubview(tableView)
        
        createConstrints()
        
        disposeBag ~ [
            viewModel.title ~> rx.title,
            viewModel.section ~> tableView.rx.items(dataSource: dataSource)
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        viewModel.reload()
    }
    
    private func createConstrints() {
        
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeArea.top)
        }
        
        logoutButton.snp.makeConstraints {
            $0.height.equalTo(Const.logout.height)
            $0.left.right.bottom.equalToSuperview()
        }
        
    }
    
}
