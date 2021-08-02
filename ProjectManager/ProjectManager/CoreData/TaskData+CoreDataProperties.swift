//
//  TaskData+CoreDataProperties.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/08/01.
//
//

import Foundation
import CoreData


extension TaskData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskData> {
        return NSFetchRequest<TaskData>(entityName: "TaskData")
    }

    @NSManaged public var title: String?
    @NSManaged public var detail: String?
    @NSManaged public var deadline: Double?
    @NSManaged public var status: String?
    @NSManaged public var id: String?

}

extension TaskData : Identifiable {

}
