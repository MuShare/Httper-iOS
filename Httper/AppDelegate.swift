//
//  AppDelegate.swift
//  Httper
//
//  Created by Meng Li on 7/24/16.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import FacebookCore
import RxSwift
import RxCocoa
import RxFlow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let coordinator = Coordinator()
    private let disposeBag = DisposeBag()
    private var appFlow: AppFlow!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        appUpdate()
        
        // Pull updated requests and push local requests(if exist) when user login.
        let user = UserManager.shared
        if user.login {
            SyncManager.shared.syncAll()
            user.pullUser(nil)
        }
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        guard let window = self.window else { return false }
        
        // Listen for Coordinator mechanism is not mandatory
        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow = \(flow) and step = \(step)")
        }).disposed(by: disposeBag)
        
        // Luach the app with an appFlow.
        appFlow = AppFlow(window: window)
        let stepper = OneStepper(withSingleStep: AppStep.main)
        coordinator.coordinate(flow: appFlow, withStepper: stepper)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        DaoManager.shared.saveContext()
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return SDKApplicationDelegate.shared.application(application,
                                                         open: url,
                                                         sourceApplication: sourceApplication,
                                                         annotation: annotation)
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return SDKApplicationDelegate.shared.application(application, open: url, options: options)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait;
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    

}

