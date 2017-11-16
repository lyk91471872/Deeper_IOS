//
//  ListMO+CoreDataProperties.swift
//  
//
//  Created by 罗宇康 on 2017/7/31.
//
//

import Foundation
import CoreData


extension ListMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListMO> {
        return NSFetchRequest<ListMO>(entityName: "List")
    }

    @NSManaged public var name: String?

}
