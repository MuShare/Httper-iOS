//
//  Request+CoreDataProperties.swift
//  Httper
//
//  Created by 李大爷的电脑 on 22/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import Foundation
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
    @NSManaged public var update: Int64
    @NSManaged public var url: String?
    @NSManaged public var revision: Int16
    @NSManaged public var rid: String?

}
