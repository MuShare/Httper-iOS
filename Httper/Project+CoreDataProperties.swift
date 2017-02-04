//
//  Project+CoreDataProperties.swift
//  Httper
//
//  Created by 李大爷的电脑 on 04/02/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project");
    }

    @NSManaged public var introduction: String?
    @NSManaged public var pid: String?
    @NSManaged public var pname: String?
    @NSManaged public var privilege: String?
    @NSManaged public var revision: Int16
    @NSManaged public var update: Int64

}
