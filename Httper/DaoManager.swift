//
//  DaoManager.swift
//  Httper
//
//  Created by 李大爷的电脑 on 22/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import CoreData

class DaoManager: NSObject {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext!
    let requestDao: RequestDao!
    
    static let sharedInstance : DaoManager = {
        let instance = DaoManager()
        return instance
    }()
    
    override init() {
        context = delegate.managedObjectContext
        requestDao = RequestDao(context)
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}
