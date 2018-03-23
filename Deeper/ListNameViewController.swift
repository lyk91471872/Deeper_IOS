//
//  ListNameViewController.swift
//  Deeper
//
//  Created by 罗宇康 on 2017/7/29.
//  Copyright © 2017年 lyk91471872. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SwiftyJSON
import Alamofire

class ListNameViewController: UITableViewController {
    //var row = Int()
    var json = String()
    var message = ""
    var lists = [ListMO]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var addNewList: UIBarButtonItem!
    @IBAction func addNewList(_ sender: UIBarButtonItem) {
        newPresetList()
        /*let selectController = UIAlertController(title: "Adding a new vocabulary list", message: "Preseted vocabulary lists available", preferredStyle: UIAlertControllerStyle.alert)
        let cancelSelectAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let newBlankListAction = UIAlertAction(title: "Blank", style: .default, handler: {
            alert -> Void in
            self.newBlankList()
        })
        let newPresetListAction = UIAlertAction(title: "Preseted", style: .default, handler: {
            alert -> Void in
            self.newPresetList()
        })
        /*let newOnlineListAction = UIAlertAction(title: "Online", style: .default, handler: {
            alert -> Void in
            self.newOnlineList()
        })*/
        selectController.addAction(cancelSelectAction)
        selectController.addAction(newBlankListAction)
        selectController.addAction(newPresetListAction)
        //selectController.addAction(newOnlineListAction)
        self.present(selectController, animated: true, completion: nil)*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func newBlankList() {
        let alertController = UIAlertController(title: "Adding New List", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let addListName = alertController.textFields![0] as UITextField
            let listName = addListName.text
            if listName != "" {
                self.message = ""
                var finalListName = listName
                var listNameIsConflicted = true
                var indexOfSameName = 0
                while listNameIsConflicted {
                    listNameIsConflicted = false
                    indexOfSameName += 1
                    for list in self.lists {
                        if list.name == finalListName {
                            finalListName = listName! + " (" + String(indexOfSameName) + ")"
                            listNameIsConflicted = true
                            break
                        }
                    }
                }
                let list = CoreDataHelper.newList()
                list.name = finalListName
                
                CoreDataHelper.saveList()
                self.lists = CoreDataHelper.retrieveLists()
                self.tableView.reloadData()
            } else {
                self.message = "List name cannot be empty!"
                self.addNewList(self.addNewList)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            self.message = ""
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Please Enter List Name"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func newPresetList() {
        let selectController = UIAlertController(title: "Please Select Subject", message: message, preferredStyle: /*UIAlertControllerStyle.alert*/.actionSheet)
        let indexJsonURL = Bundle.main.url(forResource: "index", withExtension: "json")
        let indexJsonData = try! Data(contentsOf: indexJsonURL!)
        let index = try! JSON(data: indexJsonData).arrayValue
        selectController.addAction(UIAlertAction(title: "Blank", style: .default, handler: {
            alert -> Void in
            self.newBlankList()
        }))
        for wordList in index {
            selectController.addAction(UIAlertAction(title: wordList.stringValue, style: UIAlertActionStyle.default, handler: {
                alert -> Void in
                var listName = wordList.stringValue
                var listNameIsConflicted = true
                var indexOfSameName = 0
                while listNameIsConflicted {
                    listNameIsConflicted = false
                    indexOfSameName += 1
                    for list in self.lists {
                        if list.name == listName {
                            listName = wordList.stringValue + " (" + String(indexOfSameName) + ")"
                            listNameIsConflicted = true
                            break
                        }
                    }
                }
                let list = CoreDataHelper.newList()
                list.name = listName
                let vocabJsonURL = Bundle.main.url(forResource: wordList.stringValue, withExtension: "json")
                let vocabJsonData = try! Data(contentsOf: vocabJsonURL!)
                let vocabs = try! JSON(data: vocabJsonData)["vocabularies"].arrayValue
                for word in vocabs {
                    let newWord = CoreDataHelper.newWord()
                    newWord.english = word["English"].stringValue
                    newWord.chinese = word["Chinese"].stringValue
                    newWord.familiarity = 0
                    list.addToListToWord(newWord)
                }
                CoreDataHelper.saveList()
                self.lists = CoreDataHelper.retrieveLists()
                self.tableView.reloadData()
            }))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        selectController.addAction(cancelAction)
        
        selectController.popoverPresentationController?.barButtonItem = self.addNewList
        
        self.present(selectController, animated: true, completion: nil)
    }
    
    /*func newOnlineList() {
        let filepath = Bundle.main.path(forResource: "test", ofType: "json")
        let fileManager = FileManager.default
        
        
        let alertController = UIAlertController(title: self.json, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let addListName = alertController.textFields![0] as UITextField
            let listName = addListName.text
            if listName != "" {
                self.message = ""
                var finalListName = listName
                var listNameIsConflicted = true
                var indexOfSameName = 0
                while listNameIsConflicted {
                    listNameIsConflicted = false
                    indexOfSameName += 1
                    for list in self.lists {
                        if list.name == finalListName {
                            finalListName = listName! + " (" + String(indexOfSameName) + ")"
                            listNameIsConflicted = true
                            break
                        }
                    }
                }
                let list = CoreDataHelper.newList()
                list.name = finalListName
                
                CoreDataHelper.saveList()
                self.lists = CoreDataHelper.retrieveLists()
                self.tableView.reloadData()
            } else {
                self.message = "List name cannot be empty!"
                self.setListName(self.addList)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            self.message = ""
        })
        
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "en"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }*/
    
    /*func selectSubject() {
        let selectSubjectController = UIAlertController(title: "Select Subject", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let selectAction = UIAlertAction(title: "Test", style: .default, handler: {
            alert -> Void in
            self.newList()
            
            
        })
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Refresh when view appear
        lists = CoreDataHelper.retrieveLists()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if let identifier = segue.identifier {
            if identifier == "showList" {
                let senderButton = sender as! UIButton
                let listViewController = segue.destination as! ListViewController
                listViewController.rowOfList = senderButton.tag
            } else if identifier == "showMemorizingView" {
                let senderCell = sender as! ListNameCell
                let memorizingViewController = segue.destination as! MemorizingViewController
                memorizingViewController.rowOfList = senderCell.row
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showMemorizingView" {
            let senderCell = sender as! ListNameCell
            return lists[senderCell.row].listToWord?.allObjects.count != 0
        } else {
            return true
        }
    }
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.row = indexPath.row
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNameCell", for: indexPath) as! ListNameCell
        cell.row = indexPath.row
        cell.editButton.tag = indexPath.row
        cell.listName.text = lists[indexPath.row].name
        cell.numberOfWords.text = String(lists[indexPath.row].listToWord?.count ?? 0)
        cell.table = self.tableView
       
        let words = lists[indexPath.row].listToWord?.allObjects as! [Word]
        var progress = Float()
        if words.count != 0 {
            var i = 0
            for word in words {
                if word.familiarity == 3 || word.familiarity == 4 {
                    i += 1
                }
            }
            progress = Float(i)/Float(words.count)
        } else {
            progress = 0
        }
        cell.progressView.progress = progress
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            CoreDataHelper.delete(list: lists[indexPath.row])
            
            lists = CoreDataHelper.retrieveLists()
        }
    }
}
