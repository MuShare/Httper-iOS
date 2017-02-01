//
//  DaoTemplate.swift
//  Httper
//
//  Created by 李大爷的电脑 on 22/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import CoreData

class DaoTemplate: NSObject {

    var context: NSManagedObjectContext!
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
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
