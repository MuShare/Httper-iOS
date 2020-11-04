//
//  AppDelegate.swift
//  Httper
//
//  Created by Meng Li on 7/24/16.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import FBSDKCoreKit
import RxSwift
import RxCocoa
import RxFlow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let coordinator = FlowCoordinator()
    private let disposeBag = DisposeBag()
    private let window = UIWindow()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Global.setup(application)

        FBSDKCoreKit.ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Listen for Coordinator mechanism is not mandatory
        coordinator.rx.didNavigate.subscribe(onNext: {
            AppLog.debug("did navigate to \($0) -> \($1)")
        }).disposed(by: disposeBag)
        
        // Luach the app with an appFlow.
        coordinator.coordinate(
            flow: AppFlow(window: window),
            with: OneStepper(withSingleStep: AppStep.main)
        )
        window.makeKeyAndVisible()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        DaoManager.shared.saveContext()
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return FBSDKCoreKit.ApplicationDelegate.shared.application(application, open: url, options: options)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait;
    }
    
}

