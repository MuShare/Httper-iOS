//
//  SettingsViewController.swift
//  Httper
//
//  Created by Meng Li on 2019/8/29.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

private struct Const {
    
    struct avatar {
        static let size: CGFloat = 70
        static let marginTop = 40
    }
    
    struct name {
        static let marginTop = 5
    }
    
    struct header {
        static let size = CGSize(width: UIScreen.main.bounds.width, height: 180)
    }
    
}

class SettingsViewController: BaseViewController<SettingsViewModel> {

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Const.avatar.size / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton()
        button.addSubview(avatarImageView)
        button.rx.tap.bind { [unowned self] in
            self.viewModel.signin()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var nameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightText, for: .highlighted)
        button.rx.tap.bind { [unowned self] in
            self.viewModel.signin()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.rx.tap.bind { [unowned self] in
            self.viewModel.signin()
        }.disposed(by: disposeBag)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reload()
    }
    
    override func subviews() -> [UIView] {
        [tableView]
    }
    
    override func bind() -> [Disposable] {
        [
            viewModel.avatar ~> rx.avatar,
            viewModel.name ~> nameButton.rx.title(),
            viewModel.email ~> emailButton.rx.title(),
            viewModel.sections ~> tableView.rx.items(dataSource: dataSource)
        ]
    }
    
    override func createConstraints() {
        
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeArea.top)
        }
        
        avatarButton.snp.makeConstraints {
            $0.size.equalTo(Const.avatar.size)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Const.avatar.marginTop)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nameButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(avatarButton.snp.bottom).offset(Const.name.marginTop)
        }
        
        emailButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameButton.snp.bottom)
        }

    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

private extension SettingsViewController {
    
    func setAvatar(_ avatar: URL?) {
        if let avatar = avatar {
            avatarImageView.kf.setImage(with: avatar)
        } else {
            avatarImageView.image = R.image.signin()
        }
    }
    
}

extension Reactive where Base: SettingsViewController {
    
    var avatar: Binder<URL?> {
        return Binder(base) { viewController, avatar in
            viewController.setAvatar(avatar)
        }
    }
}
