//
//  Word+CoreDataProperties.swift
//  
//
//  Created by 罗宇康 on 2017/8/1.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var english: String?
    @NSManaged public var chinese: String?
    @NSManaged public var familiarity: Int16
    @NSManaged public var wordToList: ListMO?

}
