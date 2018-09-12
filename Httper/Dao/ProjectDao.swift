//
//  ProjectDao.swift
//  Httper
//
//  Created by Meng Li on 01/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import CoreData
import SwiftyJSON

class ProjectDao: DaoTemplate {
    
    func save(pname: String, privilege: String, introduction: String) -> Project {
        let project = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(Project.self),
                                                          into: context) as! Project
        project.pname = pname;
        project.privilege = privilege;
        project.introduction = introduction;
        project.update = Int64(NSDate().timeIntervalSince1970)
        self.saveContext()
        return project;
    }
    
    func syncUpdated(_ projectObject: JSON) {
        let project = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(Project.self),
                                                          into: context) as! Project
        project.pname = projectObject["pname"].stringValue
        project.privilege = projectObject["privilege"].stringValue
        project.introduction = projectObject["introduction"].stringValue
        project.update = projectObject["updateAt"].int64Value
        // Save physical id from server.
        project.pid = projectObject["pid"].stringValue
        // Save revision
        project.revision = projectObject["revision"].int16Value
        self.saveContext()
    }

    func findAll() -> [Project] {
        let fetchRequest = NSFetchRequest<Project>(entityName: NSStringFromClass(Project.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "pname", ascending: false)]
        return try! context.fetch(fetchRequest)
    }

    func findUnsynced() -> [Project] {
        let fetchRequest = NSFetchRequest<Project>(entityName: NSStringFromClass(Project.self))
        fetchRequest.predicate = NSPredicate(format: "revision=0")
        return try! context.fetch(fetchRequest)
    }

    func findInPids(_ pids: [String]) -> [Project] {
        let fetchRequest = NSFetchRequest<Project>(entityName: NSStringFromClass(Project.self))
        fetchRequest.predicate = NSPredicate(format: "pid IN %@", pids);
        return try! context.fetch(fetchRequest)
    }
    
    func getByPid(_ pid: String) -> Project? {
        let fetchRequest = NSFetchRequest<Project>(entityName: NSStringFromClass(Project.self))
        fetchRequest.predicate = NSPredicate(format: "pid=%@", pid);
        let projects = try! context.fetch(fetchRequest)
        if projects.count == 0 {
            return nil
        }
        return projects[0]
    }
    
    func delete(_ deleteProject: Project) {
        context.delete(deleteProject)
        self.saveContext()
    }
}
