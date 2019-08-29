//
//  SettingsViewController.swift
//  Httper
//
//  Created by Meng Li on 2019/8/29.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxDataSources

private struct Const {
    
    struct avatar {
        static let size = 70
        static let marginTop = 40
    }
    
    struct header {
        static let size = CGSize(width: UIScreen.main.bounds.width, height: 180)
    }
    
}

class SettingsViewController: BaseViewController<SettingsViewModel> {
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.signin(), for: .normal)
        return button
    }()
    
    private lazy var nameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightText, for: .normal)
        return button
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: Const.header.size))
        view.addSubview(avatarButton)
        view.addSubview(nameButton)
        view.addSubview(emailButton)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .darkGray
        tableView.tableHeaderView = headerView
        tableView.rowHeight = 55
        tableView.register(cellType: SelectionTableViewCell.self)
        tableView.delegate = self
        tableView.rx.itemSelected.bind { [unowned self] in
            self.tableView.deselectRow(at: $0, animated: true)
            self.viewModel.pick(at: $0)
        }.disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SettingsSectionModel>(configureCell: { dataSoure, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(for: indexPath) as SelectionTableViewCell
        cell.configure(item)
        cell.titleAlignment = .left
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        view.addSubview(tableView)
        createConstraints()
        
        disposeBag ~ [
            viewModel.sections ~> tableView.rx.items(dataSource: dataSource)
        ]
    }
    
    private func createConstraints() {
        
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeArea.top)
        }
        
        avatarButton.snp.makeConstraints {
            $0.size.equalTo(Const.avatar.size)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Const.avatar.marginTop)
        }
        
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
