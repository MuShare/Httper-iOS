//
//  MainViewController.swift
//  Httper
//
//  Created by Meng Li on 04/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
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
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.localizable.tab_request_clear(), style: .plain, target: self, action: #selector(clearRequest))
        case .project:
            title = R.string.localizable.tab_project_title()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        case .settings:
            title = ""
        }
    }
    
    @objc private func addNewProject() {
        guard let controller = selectedViewController, controller.isKind(of: ProjectsViewController.self) else {
            return
        }
        controller.performSegue(withIdentifier: R.segue.projectsViewController.addProjectSegue.identifier, sender: controller)
    }
    
    @objc private func clearRequest() {
        guard let controller = selectedViewController, controller.isKind(of: RequestViewController.self) else {
            return
        }
        let requestViewController = controller as! RequestViewController
//        requestViewController.clearRequest(navigationItem.rightBarButtonItem!)
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
