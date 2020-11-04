//
//  Request+CoreDataProperties.swift
//  Httper
//
//  Created by lidaye on 15/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import CoreData

extension Request {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Request> {
        return NSFetchRequest<Request>(entityName: "Request");
    }

    @NSManaged public var body: NSData?
    @NSManaged public var bodytype: String?
    @NSManaged public var headers: NSData?
    @NSManaged public var method: String?
    @NSManaged public var parameters: NSData?
    @NSManaged public var revision: Int16
    @NSManaged public var rid: String?
    @NSManaged public var update: Int64
    @NSManaged public var url: String?
    @NSManaged public var project: Project?

}
