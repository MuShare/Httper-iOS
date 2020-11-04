//
//  Project+CoreDataProperties.swift
//  Httper
//
//  Created by lidaye on 15/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

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
    @NSManaged public var requests: NSOrderedSet?

}

// MARK: Generated accessors for requests
extension Project {

    @objc(insertObject:inRequestsAtIndex:)
    @NSManaged public func insertIntoRequests(_ value: Request, at idx: Int)

    @objc(removeObjectFromRequestsAtIndex:)
    @NSManaged public func removeFromRequests(at idx: Int)

    @objc(insertRequests:atIndexes:)
    @NSManaged public func insertIntoRequests(_ values: [Request], at indexes: NSIndexSet)

    @objc(removeRequestsAtIndexes:)
    @NSManaged public func removeFromRequests(at indexes: NSIndexSet)

    @objc(replaceObjectInRequestsAtIndex:withObject:)
    @NSManaged public func replaceRequests(at idx: Int, with value: Request)

    @objc(replaceRequestsAtIndexes:withRequests:)
    @NSManaged public func replaceRequests(at indexes: NSIndexSet, with values: [Request])

    @objc(addRequestsObject:)
    @NSManaged public func addToRequests(_ value: Request)

    @objc(removeRequestsObject:)
    @NSManaged public func removeFromRequests(_ value: Request)

    @objc(addRequests:)
    @NSManaged public func addToRequests(_ values: NSOrderedSet)

    @objc(removeRequests:)
    @NSManaged public func removeFromRequests(_ values: NSOrderedSet)

}
