//
//  CoreDataHelper.swift
//  Deeper
//
//  Created by 罗宇康 on 2017/7/31.
//  Copyright © 2017年 lyk91471872. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    //static methods will go here
    static func newList() -> ListMO {
        let list = NSEntityDescription.insertNewObject(forEntityName: "List", into: managedContext) as! ListMO
        return list
    }
    
    static func newWord() -> Word {
        let word = NSEntityDescription.insertNewObject(forEntityName: "Word", into: managedContext) as! Word
        return word
    }
    
    static func saveList() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func delete(list: ListMO) {
        managedContext.delete(list)
        saveList()
    }
    
    static func deleteWord(word: Word) {
        managedContext.delete(word)
        saveList()
    }
    
    static func retrieveLists() -> [ListMO] {
        let fetchRequest = NSFetchRequest<ListMO>(entityName: "List")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
