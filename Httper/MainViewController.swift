//
//  MainViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 04/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

enum MainTabType {
    case request
    case project
    case settings
}

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

        tabBar.barTintColor = UIColor(hex: 0x42474b)
        tabBar.tintColor = UIColor(hex: 0xffffff)
        
        let requestViewController = R.storyboard.main.requestViewController()!
        requestViewController.tabBarItem = UITabBarItem(title: R.string.localizable.tab_request(),
                                                        image: R.image.tab_request(),
                                                        tag: 0)
        
        let projectsViewController = R.storyboard.main.projectsViewController()!
        projectsViewController.tabBarItem = UITabBarItem(title: R.string.localizable.tab_project(),
                                                              image: R.image.tab_project(),
                                                              tag: 1)
        
        let settingsTableViewController = R.storyboard.settings.settingsTableViewController()!
        settingsTableViewController.tabBarItem = UITabBarItem(title: R.string.localizable.tab_settings(),
                                                              image: R.image.tab_settings(),
                                                              tag: 2)
        
        viewControllers = [requestViewController, projectsViewController, settingsTableViewController]
        updateNavigationBar(with: .request)
    }
    
    private func updateNavigationBar(with type: MainTabType) {
        switch type {
        case .request:
            title = R.string.localizable.tab_request_title()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearRequest))
        case .project:
            title = R.string.localizable.tab_project_title()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewProject))
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
        requestViewController.clearRequest(navigationItem.rightBarButtonItem!)
    }
    
}

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.isKind(of: RequestViewController.self) {
            updateNavigationBar(with: .request)
        } else if viewController.isKind(of: ProjectsViewController.self) {
            updateNavigationBar(with: .project)
        } else if viewController.isKind(of: SettingsTableViewController.self) {
            updateNavigationBar(with: .settings)
        }
    }
    
}
