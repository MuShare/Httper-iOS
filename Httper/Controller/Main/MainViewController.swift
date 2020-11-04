//
//  MainViewController.swift
//  Httper
//
//  Created by Meng Li on 04/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import RxSwift

enum MainTabType: Int {
    case request = 0
    case project
    case settings
    
    var tabTitle: String {
        switch self {
        case .request:
            return R.string.localizable.tab_request()
        case .project:
            return R.string.localizable.tab_project()
        case .settings:
            return R.string.localizable.tab_settings()
        }
    }
    
    var tabImage: UIImage? {
        switch self {
        case .request:
            return R.image.tab_request()
        case .project:
            return R.image.tab_project()
        case .settings:
            return R.image.tab_settings()
        }
    }
}

class MainViewController: UITabBarController {
    
    private lazy var clearRequestBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.style = .plain
        barButtonItem.title = R.string.localizable.tab_request_clear()
        barButtonItem.rx.tap.bind { [unowned self] in
            self.viewModel.clearRequest()
        }.disposed(by: disposeBag)
        return barButtonItem
    }()
    
    private lazy var addRequestBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        barButtonItem.rx.tap.bind { [unowned self] in
            self.viewModel.addProject()
        }.disposed(by: disposeBag)
        return barButtonItem
    }()

    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var viewControllers: [UIViewController]? {
        didSet {
            guard let viewControllers = viewControllers, viewControllers.count > 0 else {
                return
            }
            for (index, viewController) in viewControllers.enumerated() {
                let type = MainTabType(rawValue: index)
                viewController.tabBarItem = UITabBarItem(title: type?.tabTitle, image: type?.tabImage, tag: index)
            }
            updateNavigationBar(with: .request)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        tabBar.barTintColor = UIColor(hex: 0x42474b)
        tabBar.tintColor = UIColor(hex: 0xffffff)
        
    }
    
    private func updateNavigationBar(with type: MainTabType) {
        switch type {
        case .request:
            title = R.string.localizable.tab_request_title()
            navigationItem.rightBarButtonItem = clearRequestBarButtonItem
        case .project:
            title = R.string.localizable.tab_project_title()
            navigationItem.rightBarButtonItem = addRequestBarButtonItem
        case .settings:
            title = R.string.localizable.tab_settings()
            navigationItem.rightBarButtonItem = nil
        }
    }
    
}

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabType = MainTabType(rawValue: tabBarController.selectedIndex) else {
            return
        }
        updateNavigationBar(with: tabType)
    }
    
}
